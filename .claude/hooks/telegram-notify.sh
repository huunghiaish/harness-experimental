#!/usr/bin/env bash
# Telegram notifier for Claude Code hooks.
# Reads the hook event JSON from stdin and pushes a short message to Telegram.
# Required env: TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID
# Optional env: TELEGRAM_NOTIFY_SILENT=1 (sends with disable_notification=true)
#
# Behaviors:
# - Notification: includes the agent's last-assistant text snippet so the
#   human sees WHAT attention is needed (not just a generic "needs input").
# - Stop: if the last assistant turn contains a MANUAL_CHECKPOINT block,
#   posts the block AND auto-attaches any repo-relative reference files
#   it lists (docs/**, plans/**, scripts/**, tests/**) via
#   .claude/scripts/telegram-send.sh — so claude.ai/design / SOW review /
#   UAT walkthroughs arrive with their reference material already in Telegram.

set -uo pipefail

# Never block Claude Code: any failure here exits 0 so the hook stays non-fatal.
trap 'exit 0' ERR

# Auto-load .claude/.env if present (env vars from shell still win — set -a + source
# only assigns vars that aren't already exported).
env_file="${CLAUDE_PROJECT_DIR:-$(pwd)}/.claude/.env"
if [[ -f "$env_file" ]]; then
  set -a
  # shellcheck disable=SC1090
  source "$env_file"
  set +a
fi

if [[ -z "${TELEGRAM_BOT_TOKEN:-}" || -z "${TELEGRAM_CHAT_ID:-}" ]]; then
  exit 0
fi

payload=$(cat)
event=$(printf '%s' "$payload" | jq -r '.hook_event_name // "unknown"')
cwd=$(printf '%s' "$payload" | jq -r '.cwd // "?"')
session=$(printf '%s' "$payload" | jq -r '.session_id // "?"' | cut -c1-8)
tpath=$(printf '%s' "$payload" | jq -r '.transcript_path // ""')
host=$(hostname -s 2>/dev/null || echo "host")

# Read last assistant message text from transcript (used by Notification + Stop).
# Returns the concatenated text content blocks of the most recent assistant turn,
# empty string if not found.
last_assistant_text() {
  local _tp="$1" _json
  [[ -n "$_tp" && -f "$_tp" ]] || return 0
  _json=$(tac "$_tp" 2>/dev/null | while IFS= read -r ln; do
    if printf '%s' "$ln" | jq -e '.type=="assistant"' >/dev/null 2>&1; then
      printf '%s' "$ln"
      break
    fi
  done)
  [[ -n "$_json" ]] || return 0
  printf '%s' "$_json" \
    | jq -r '.message.content // [] | map(select(.type=="text") | .text) | join("\n\n")' 2>/dev/null
}

# Extract repo-relative reference paths from a text blob, filter to files that
# actually exist under $cwd, dedupe, cap at $3 (default 12). Used to auto-attach
# MANUAL_CHECKPOINT references.
extract_referenced_files() {
  local _text="$1" _cwd="$2" _max="${3:-12}"
  # Path roots agents commonly reference. Extend if your repos use more.
  local _re='(docs|plans|scripts|tests?|src|app|public|assets)/[A-Za-z0-9._/-]+\.(md|txt|json|yaml|yml|toml|pdf|png|jpe?g|gif|svg|webp|html|csv|tsv|mp4|webm|zip|tar\.gz)'
  printf '%s\n' "$_text" \
    | grep -oE "$_re" \
    | awk '!seen[$0]++' \
    | head -n "$_max" \
    | while IFS= read -r p; do
        [[ -f "${_cwd}/${p}" ]] && printf '%s\n' "$p"
      done
}

last_full=""
manual_block=""

case "$event" in
  Notification)
    # `.message` is the framework-provided reason (permission ask, idle, etc.).
    # Now we ALSO surface what the agent was just saying so the human knows
    # what to attend to (not just "needs input").
    msg=$(printf '%s' "$payload" | jq -r '.message // "(no message)"')
    last_full=$(last_assistant_text "$tpath")

    last_snip=""
    if [[ -n "$last_full" ]]; then
      # Trim to ~700 chars and strip trailing whitespace.
      last_snip=$(printf '%s' "$last_full" | head -c 700 | sed -e 's/[[:space:]]*$//')
    fi

    text="[Claude] needs attention: ${msg}
host: ${host}
session: ${session}
dir: ${cwd}"
    if [[ -n "$last_snip" ]]; then
      # Mark snippet so it's obvious it's context, not the literal reason.
      text="${text}

— what attention is needed (last assistant turn, trimmed):
${last_snip}"
    fi
    ;;

  Stop)
    last_full=$(last_assistant_text "$tpath")

    if [[ -n "$last_full" ]] && printf '%s' "$last_full" | grep -q 'MANUAL_CHECKPOINT'; then
      # Capture from the first MANUAL_CHECKPOINT line to end of assistant text.
      # Blocks separated by blank lines stay together; trailing prose is
      # included (it usually clarifies what the human should do next).
      manual_block=$(printf '%s' "$last_full" | awk '/MANUAL_CHECKPOINT/{p=1} p{print}' | head -c 3500)
      text="[MANUAL CHECKPOINT] Claude is waiting on offline work
host: ${host}
session: ${session}
dir: ${cwd}

${manual_block}"
    else
      last_line=$(printf '%s' "$last_full" | head -n 1 | cut -c1-300)
      text="[Claude] turn finished
host: ${host}
session: ${session}
dir: ${cwd}"
      if [[ -n "$last_line" ]]; then
        text="${text}

last: ${last_line}"
      fi
    fi
    ;;

  *)
    text="[Claude] event: ${event}
host: ${host}
session: ${session}
dir: ${cwd}"
    ;;
esac

disable_notif="false"
[[ "${TELEGRAM_NOTIFY_SILENT:-0}" == "1" ]] && disable_notif="true"

curl -fsS -m 5 -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
  --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
  --data-urlencode "text=${text}" \
  --data-urlencode "disable_notification=${disable_notif}" \
  > /dev/null 2>&1 || true

# Stop-event auto-attach: send any reference files the MANUAL_CHECKPOINT block
# mentions so claude.ai/design / SOW review / UAT etc. arrive ready-to-use.
if [[ "$event" == "Stop" && -n "$manual_block" ]]; then
  helper="${cwd}/.claude/scripts/telegram-send.sh"
  if [[ -x "$helper" ]]; then
    mapfile -t refs < <(extract_referenced_files "$manual_block" "$cwd" 12)
    if (( ${#refs[@]} > 0 )); then
      abs_refs=()
      for r in "${refs[@]}"; do
        abs_refs+=("${cwd}/${r}")
      done
      CLAUDE_PROJECT_DIR="$cwd" "$helper" \
        --caption "[MANUAL CHECKPOINT refs] ${#refs[@]} file(s) referenced above" \
        "${abs_refs[@]}" \
        > /dev/null 2>&1 || true
    fi
  fi
fi

exit 0
