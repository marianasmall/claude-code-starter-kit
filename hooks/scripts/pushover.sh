#!/bin/bash
# Shared Pushover helper — called by other hooks to push notifications to a phone.
# Usage: source pushover.sh && send_pushover "title" "message" [priority] [url] [url_title]
#   priority: -1=low, 0=normal, 1=high (bypasses quiet hours)
#   url: tappable link in the notification (optional)
#   url_title: label for the link (optional, defaults to "Open")
#
# Setup: requires Pushover account (https://pushover.net). Add to ~/.env.local:
#   PUSHOVER_USER_KEY=your_user_key
#   PUSHOVER_API_TOKEN=your_app_token
# Falls back silently if credentials are missing — safe to ship enabled.
#
# Debounce: won't send more than 1 push per DEBOUNCE_SECONDS (default 180 = 3 min)
# to prevent spam during active work. Override with PUSHOVER_DEBOUNCE.

DEBOUNCE_SECONDS="${PUSHOVER_DEBOUNCE:-180}"
DEBOUNCE_FILE="/tmp/claude-pushover-last-sent"

# Load credentials
if [ -f "$HOME/.env.local" ]; then
    export $(grep -E '^PUSHOVER_' "$HOME/.env.local" | xargs)
fi

send_pushover() {
    local title="${1:-Claude Code}"
    local message="${2:-Notification from Claude Code}"
    local priority="${3:-0}"
    local url="${4:-}"
    local url_title="${5:-Open}"

    # Check credentials — silently skip if missing (so this is safe to ship enabled)
    if [ -z "$PUSHOVER_USER_KEY" ] || [ -z "$PUSHOVER_API_TOKEN" ]; then
        return 1
    fi

    # Debounce check
    if [ -f "$DEBOUNCE_FILE" ]; then
        local last_sent=$(cat "$DEBOUNCE_FILE" 2>/dev/null)
        local now=$(date +%s)
        local elapsed=$((now - last_sent))
        if [ "$elapsed" -lt "$DEBOUNCE_SECONDS" ]; then
            return 0  # silently skip, too soon
        fi
    fi

    # Build curl args
    local curl_args=(
        -s -o /dev/null
        --form-string "token=$PUSHOVER_API_TOKEN"
        --form-string "user=$PUSHOVER_USER_KEY"
        --form-string "title=$title"
        --form-string "message=$message"
        --form-string "priority=$priority"
    )

    # Add URL if provided (makes notification tappable)
    if [ -n "$url" ]; then
        curl_args+=(--form-string "url=$url" --form-string "url_title=$url_title")
    fi

    # Send notification (background, doesn't block hook completion)
    curl "${curl_args[@]}" https://api.pushover.net/1/messages.json &

    # Update debounce timestamp
    date +%s > "$DEBOUNCE_FILE"
}
