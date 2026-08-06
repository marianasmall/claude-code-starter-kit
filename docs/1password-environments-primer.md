# Get your API keys off your disk: a 1Password Environments primer

*Verified working August 2026 on a 1Password Families plan, macOS, 1Password 8 desktop app. Feature availability and UI details will shift. The walkthrough below has your Claude verify each step against your actual account rather than trusting this document.*

---

## Who this is for

You, if all of these are true:

- You use 1Password (any plan; this works on Families, not just Business)
- You use Claude Code with hooks, scripts, or MCP servers that need API keys
- Those keys currently live in a plaintext file on your Mac, a `.env` or `.env.local`, because that's what every tutorial told you to do

That last one is the problem this primer solves. If you've ever thought "it feels wrong that my Pushover token is just *sitting there* in a text file," your instinct was right.

## What this gives you

1Password shipped a feature called Environments (announced alongside their July 2026 Privileged Access launch). It manages your project's environment variables and serves them to your tools through something cleverer than a file.

Here's the trick, in plain terms: the "`.env` file" it creates on your disk isn't a file — it's a serving hatch. A normal file holds its contents on disk, where anything can read them, forever. The hatch holds nothing. Literally zero bytes; it's a named pipe, if you want the technical term. When a program opens it to read, 1Password gets asked in that moment and passes the values through. Close it, and nothing is left behind.

What that means in practice, all verified by hand:

| 1Password state | What your scripts see |
|---|---|
| Running + unlocked | Secrets served instantly |
| Running + locked | The read waits → macOS asks for your password → then serves |
| Quit entirely | The hatch vanishes from disk. Scripts fail instantly and cleanly, no hang |
| Just launched, not yet unlocked | Hatch absent until your first unlock |

Compare that to a plaintext `.env` file, which has exactly one row in its table: *readable by everything, always, including when you're not home.*

## Why this matters for Claude Code specifically

Your AI assistant reads files. That's its job. Claude Code reads your hooks, your scripts, your config, and if your secrets sit in a plaintext file those tools reference, secrets can end up in session transcripts and context windows you never intended. With Environments there's no file to read. The secrets exist only in the moment a tool that needs them asks.

Hooks make this worse than it sounds. If you use hooks for notifications, sync scripts, or session logging, they probably `source` a plaintext env file dozens of times a day, which makes that file the single most-read secret store on your machine. Moving it behind the hatch upgrades every hook at once.

And the security world already settled this argument. 1Password's own research says roughly 40% of developers grant AI agents persistent access to credentials, and the accepted fix is "secrets appear just-in-time, never at rest." This feature is that fix, running on a password manager you already pay for. No new subscription, no new tool.

Honest limits, before you commit:

- **Not for headless or always-on machines.** The hatch requires *you* to unlock 1Password interactively. A 24/7 automation server can't type a password; for those, use 1Password service accounts instead. This is for the Mac you sit at.
- **The CLI can't read Environments yet** (as of `op` 2.38.1 stable, the `op environment` commands are beta-channel only). The desktop app does all the work here, so this doesn't block anything below.
- **After a reboot, secrets are unavailable until your first 1Password unlock.** Your hooks should skip gracefully, not crash. The loader snippet below handles this.

---

## The setup, start to finish

You can do this by hand with the steps below, or (better) paste the companion prompt at the bottom of this doc into Claude Code and let your Claude drive, checking each step as you go. The whole thing takes about 20 minutes.

### Step 0 — Confirm your plan has it

Sign in to your account at `your-account.1password.com`, then click **Developer** in the left sidebar. If you see an **Environments** tab, you're in. Verified present on a Families plan; 1Password's marketing calls these "Enterprise Password Manager" features, but that's framing, not a paywall.

### Step 1 — Create the environment

In the 1Password desktop app: **Developer → Environments → New environment**. Name it for its job, e.g. `Claude Code Hooks`.

When asked which vault to use, pick or create a dedicated vault for Claude-related secrets rather than your personal vault. Access is granted per-vault, so a dedicated vault keeps the blast radius small: anything that can read this environment sees only Claude's secrets, not your banking logins.

### Step 2 — Import your variables

On the environment's page, use **Import .env file** and select your existing plaintext file (`~/.env.local` or wherever yours lives).

- The file is hidden in the file picker. Press **⌘ + Shift + .** to reveal hidden files.
- Alternative: drag the file from Finder onto the "Add your variables here" box. If you can't find it in Finder, run `open -R ~/.env.local` in a terminal and Finder opens with it highlighted.

One naming trap. If you already keep these secrets in a regular 1Password item (many people have an "API Keys" item), know that the *item* and the *environment* are different containers that don't sync. Importing creates a second copy. That's fine for now; decide on one canonical home at the end.

### Step 3 — Mount the hatch

On the environment page: **Connect to → Local .env file → Connect**.

- File name: keep `.env`.
- Location: choose a new, dedicated folder such as `~/.claude/env/`. Don't point it at the folder where your real plaintext file lives; you don't want a collision before you've verified anything.
- macOS will ask "Are you sure you want to use a name that begins with a period?" Click **Use "."** — env files are conventionally hidden, and this is normal.
- Click **Mount .env file**. The workflow should show **Enabled** with the path listed, and the page will tell you: "Your secrets will not be stored on disk." That's the whole point, in their words.

### Step 4 — Verify it (without leaking anything)

Rule one of testing secret infrastructure: **never print the secrets.** Anything printed lands in your terminal scrollback and your Claude Code transcript, which is the exact exposure you're eliminating. We learned this the embarrassing way so you don't have to.

Have Claude verify with this approach (or paste the companion prompt and it will):

- Confirm the mount is a pipe, not a file: `[ -p ~/.claude/env/.env ] && echo "pipe present"`
- Compare values by fingerprint, never by printing: load each variable from the pipe and from your old plaintext file in separate clean shells, hash both with `shasum -a 256`, compare hashes. Report only `MATCH` or `MISMATCH` per name.
- Test the locked state: lock 1Password and read again. Expect a macOS password prompt, then success.
- Test the quit state: quit 1Password fully, confirm the pipe vanishes, and confirm reads fail instantly. Check the quit actually took with `pgrep -x 1Password`; ⌘Q sometimes only closes the window while the app keeps running in the menu bar.

### Step 5 — The loader snippet (this part is load-bearing)

Here's the trap that will silently burn you: macOS ships bash 3.2, from 2007, and its `source` command checks a file's size before reading its contents. A pipe always reports 0 bytes, so `source ~/.claude/env/.env` **succeeds while loading absolutely nothing**. No error, no warning, empty variables.

Every script that consumes the mount needs this pattern instead:

```bash
# Load secrets from the 1Password Environments mount.
# NEVER `source` the pipe directly — bash 3.2 silently reads 0 bytes from FIFOs.
ENV_PIPE="$HOME/.claude/env/.env"
if [ -p "$ENV_PIPE" ]; then
  set -a
  eval "$(perl -e 'alarm 10; exec @ARGV' cat "$ENV_PIPE" 2>/dev/null)"
  set +a
fi
# If the pipe is absent (1Password not running / not yet unlocked),
# variables stay unset — scripts should skip their action, not crash.
```

The `alarm 10` timeout matters. If 1Password is locked, the read waits for you to approve a password prompt, and without a timeout a hook could stall your session start while the dialog sits unnoticed behind other windows.

### Step 6 — Migrate, bake in, retire

1. Find every consumer of your old plaintext file: `grep -rl "env.local" ~/.claude/hooks/` (adjust paths to your setup).
2. Swap each one to the loader snippet.
3. Keep the old plaintext file in place for a week while you confirm every hook still works.
4. Then retire it reversibly. Move it to a review folder (`mkdir -p ~/review-for-deletion && mv ~/.env.local ~/review-for-deletion/env.local.retired-$(date +%Y-%m-%d)`) rather than deleting. Delete for real once you've forgotten it was ever there.
5. Resolve the duplicate-storage question from Step 2: pick one canonical home for these secrets (the environment is the natural choice now) and note it wherever you document your setup.

---

## Companion prompt — paste this into Claude Code

> I want to move my API keys out of a plaintext env file and into 1Password Environments, following the primer at `docs/1password-environments-primer.md` in the claude-code-starter-kit repo (read it first if you have it; otherwise fetch it from the repo). Walk me through it step by step: verify my plan has Environments, guide me through the desktop app clicks one checkpoint at a time (I'll tell you "done" after each), and run the verification yourself. Hard rules: never print a secret value to the terminal or transcript; compare by SHA-256 fingerprint only. Never modify or delete my existing env file until I explicitly approve the final retirement step. Warn me before any step that could trigger a password prompt. My env file is at: [YOUR PATH, e.g. ~/.env.local]

---

## FAQ

**Does this protect me if my Mac is stolen?** Yes, and that's its strongest scenario. With the machine off or 1Password locked, the secrets exist nowhere on disk. A plaintext `.env` file is readable by anyone who gets your disk.

**Does this protect me from malware running as my user while I'm working?** Only partially. While 1Password is unlocked, anything running as you can read the hatch, same as it could read the plaintext file. The upgrade is at-rest protection, not runtime isolation. (Nothing file-based gives you runtime isolation.)

**What about my other machine / a server / a Raspberry Pi?** Not this feature; it needs interactive unlock. Look at 1Password service accounts (the `op` CLI with a service account token) for headless use.

**The mounted file disappeared!** 1Password isn't running, or hasn't been unlocked since launch. Open and unlock it and the hatch comes back. This is by design.

**Can I edit the mounted file?** No, it's generated. Edit variables in the 1Password app; the hatch serves whatever the environment currently holds.
