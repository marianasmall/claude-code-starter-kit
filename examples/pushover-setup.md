# Pushover Setup

Pushover is a simple paid service ($5 one-time per platform) for sending push notifications to your phone. Several hooks in this kit can use it for alerts.

## Why bother

Without Pushover, the hooks fall back to macOS-only `osascript` notifications, which:
- Don't reach you when you're away from your laptop
- Get lost in macOS Notification Center clutter

Pushover gives you alerts on your phone, which is usually where you actually are.

## What gets notified

If Pushover is configured, the kit will send notifications for:

- **Permission requests** (`permission-ding.sh`) — Claude is waiting for your approval to run a tool
- **Context low warnings** (`context-monitor.sh`) — Session is approaching context limit, time to save
- **Maintenance reminders** (if you set up a cron job from `examples/maintain-launchd.plist`)

All notifications are debounced (default 3 minutes) so you don't get spammed during active work.

## Setup

### 1. Sign up

https://pushover.net — create an account. The Pushover team is small and trustworthy.

### 2. Buy the iPhone or Android app ($5 one-time)

Or use the desktop app or web client. The phone app is the most useful.

### 3. Get your User Key

After signing in, your User Key is on the dashboard. It's a 30-character string starting with `u`.

### 4. Create an app token

Go to https://pushover.net/apps/build → create a new app named (for example) "Claude Code." Get the API Token from the resulting page.

### 5. Save credentials

Create or edit `~/.env.local`:

```
PUSHOVER_USER_KEY=your_user_key_here
PUSHOVER_API_TOKEN=your_api_token_here
```

Make sure permissions are tight:

```
chmod 600 ~/.env.local
```

### 6. Test

```
source ~/.env.local
curl -s \
  --form-string "token=$PUSHOVER_API_TOKEN" \
  --form-string "user=$PUSHOVER_USER_KEY" \
  --form-string "title=Test" \
  --form-string "message=Pushover is working" \
  https://api.pushover.net/1/messages.json
```

You should get a notification on your phone within seconds.

### 7. Verify the hook integration

Open a Claude Code session and trigger a permission request (e.g., ask it to do something that requires approval). The `permission-ding.sh` hook should send a Pushover notification.

## Customizing

### Debounce window

By default, Pushover notifications are debounced to 1 per 3 minutes. Override:

```
export PUSHOVER_DEBOUNCE=300  # 5 minutes
```

Or for a single high-priority notification, the hook can pass `PUSHOVER_DEBOUNCE=0` inline (some hooks already do this — see `permission-ding.sh`).

### Priority

Hooks can pass priority levels to Pushover:

- `-2` → silent (no sound, no vibrate)
- `-1` → low (no sound at quiet hours)
- `0` → normal (default)
- `1` → high (bypasses quiet hours)
- `2` → emergency (repeats until acknowledged)

Most hooks use `0` or `1`. Don't use `2` from a hook — it's overkill.

## Troubleshooting

**No notifications arriving:**
- Check `~/.env.local` exists and has both keys
- Verify `chmod 600 ~/.env.local`
- Test with the curl command in step 6
- Check Pushover dashboard for failed-delivery records

**Too many notifications:**
- Increase `PUSHOVER_DEBOUNCE`
- Disable specific hooks (edit `hooks/hooks.json`)
- Remove specific notification calls inside hook scripts

**Notifications fire from the wrong session:**
- Hooks identify the session via `session_id`. If you're running parallel sessions, each will fire its own notifications. There's currently no way to silence one session's hooks while leaving others active.

## Without Pushover

Every hook in this kit gracefully no-ops when Pushover credentials are missing. You'll still get:
- Mac notifications via `osascript` (when on macOS)
- The hooks' core behavior (warnings, context injection, etc.) without phone alerts

So Pushover is purely additive. If you don't want to pay $5 + sign up for another service, the kit works fine without it.
