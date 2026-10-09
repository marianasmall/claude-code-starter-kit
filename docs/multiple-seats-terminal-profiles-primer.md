# Multiple Claude seats: one Terminal profile each

If you have more than one Claude account, for example a personal plan and your employer's Team or Enterprise seat, it's easy to start a session in the wrong one. This primer sets up a Terminal profile (Mac) for each seat. Each one has its own colour and opens its own account, so you can tell them apart before you type anything.

The end result, in **Shell → New Window**:

| Profile | Look | Opens |
|---|---|---|
| `1-My-Claude` | Clear Dark | your personal seat, in your home folder |
| `2-Work` | pale pink (or any colour) | your work seat, in your work folder |

## How two seats coexist

Claude Code keeps everything (login, settings, history, memory) in `~/.claude`. A second seat gets its own folder, and the `CLAUDE_CONFIG_DIR` setting tells Claude Code which folder to use. Plain `claude` stays your personal seat. A short command such as `work` opens the other one.

Add this to `~/.zshrc` (ask Claude to do it, with a backup first):

```zsh
# Work Claude seat: separate login, settings and history in ~/.claude-work
work() {
  mkdir -p "$HOME/Work"
  cd "$HOME/Work"
  CLAUDE_CONFIG_DIR="$HOME/.claude-work" claude "$@"
}
```

Run `work` once and log in with your work account. From then on, `claude` opens your personal seat and `work` opens the work seat.

Setting `CLAUDE_CONFIG_DIR` inline, on the same line as `claude`, means it applies to that one launch only. If you `export` it instead, every later `claude` in that window opens the work seat by mistake.

## Make a profile per seat

1. **Terminal → Settings → Profiles.** Pick a look you like (Clear Dark, Basic…), click the **⋯** button at the bottom, then **Duplicate Profile**.
2. Rename the copy by double-clicking its name.
3. On the **Text** tab, set the **Background** colour. A distinct colour per seat is the whole point.
4. On the **Shell** tab, under **Startup**, tick **Run command** and type a single word: `claude` for the personal profile, `work` for the work one. Also tick **Run inside shell**, so that quitting Claude drops you back at your normal prompt instead of "[Process completed]".
5. Open **Shell → New Window → [your profile]** to test it, then type `/status` to check which account you're signed into.

## Traps we hit (so you don't)

- **No quote marks in the startup command.** Terminal wraps the command in its own quotes, so `zsh -ic 'cd ~ && claude'` fails with `zsh:1: unmatched '` and the window closes. Keep it to one word, and put anything fancier in a shell function like `work()` above.
- **Profiles are sorted alphabetically and can't be dragged.** To put yours at the top, start the names with a number: `1-My-Claude`, `2-Work`.
- **An imported `.terminal` file takes its name from the file name**, not from the name saved inside it. Name the file exactly what you want the profile to be called.
- **Deleting a profile before re-importing it.** Terminal can keep two profiles with the same name. Remove the broken one with **−** before importing a fixed copy.
- **"Do you trust this folder?" on every launch.** Claude Code asks this once per folder. If it keeps asking for your home folder, have the profile start somewhere you've already trusted, such as `~/Projects`. You can also ask Claude to mark the home folder as trusted for that seat; the setting is `hasTrustDialogAccepted` for that folder in the seat's `.claude.json`, so take a backup first.
- **Two sessions editing Terminal settings at once.** If you ask both seats to fix their profiles, let one session do the work. Otherwise they overwrite each other's changes.

## Keep a copy

Once a profile works, export it (**⋯ → Export…**) to somewhere like `~/.config/terminal/`. If a later change breaks it, double-clicking the file restores it.

## Going further

- **Colour the window from the shell command itself.** The `work` function can switch the open window to its colour with a short AppleScript and switch it back when the session ends. Then any window you type `work` in turns that colour, not only windows opened from the profile.
- **Match your browser.** If your work seat uses a separate Chrome profile, give it the same colour, so the Terminal and the browser for each seat look alike.
- **Keyboard shortcuts.** In System Settings → Keyboard → Keyboard Shortcuts → App Shortcuts, add one for Terminal using the exact profile name (for example `1-My-Claude`) to open that seat with one key combination.
