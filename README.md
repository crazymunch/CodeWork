# CodeWork: Code agent → browser tester handoff

Lets a Claude Code agent (cloud or local) hand a browser test to a **tester agent driving your real Chrome**, wait for it, and read its findings back, with no relaying by you. You can watch the tester's tab, take over, and it uses your existing sign-ins.

```
 cloud / local Code agent                       your computer
 ┌──────────────────────────┐  create_session  ┌──────────────────────────────┐
 │ delegate-browser-test    │ ───────────────▶ │ claude remote-control        │
 │  1 find bridge env       │   (brief = the   │   --chrome  (~/claude-tester)│
 │  2 write HANDOFF-BRIEF   │    prompt)       │  tester session              │
 │  4 bg timer, re-check    │                  │  browser-tester skill        │
 │  5 list_events → report  │ ◀─────────────── │  drives Chrome, ends with    │
 │  6 fix, new round        │  read transcript │  <<<HANDOFF-REPORT … >>>     │
 └──────────────────────────┘                  └──────────────────────────────┘
```

## What was proven (spike, 2026-11-03)

| Path | Result |
|---|---|
| Cloud Code → start a session on your Mac (`create_session` on the `bridge` environment) | ✅ after a one-time trusted-device approval |
| Tester drives real Chrome via Claude in Chrome | ✅ new tab, page read, tab left open |
| Tester → lead via `send_message` | ❌ refused: `elevated_session_untrusted_device` |
| Tester → lead via `fire_trigger` into the lead | ❌ fired, but never delivered to the lead |
| Lead reads tester's final message with `list_events` | ✅ the return channel this design uses |
| Lead wakes itself with `send_later` after the trusted-device approval | ❌ fired, failed with `ACCESS_DENIED`. The lead waits with a background shell timer instead. |
| Lead → tester follow-up via `send_message` | ⚠️ delivered, but treated as peer data: tester asks you before acting. So each round is a **new** tester session with a full brief. |
| Cloud Code → **Cowork** agent | ❌ no Cowork environment for `create_session`, and Cowork sessions are not listable. Claude in Chrome gives the tester the same browser capability Cowork has. |

## Setup (once)

### 1. Tester workspace on your computer

```bash
git clone https://github.com/crazymunch/CodeWork.git ~/CodeWork
```

```bash
~/CodeWork/scripts/install-tester.sh
```

```bash
cd ~/claude-tester && claude remote-control --chrome
```

That creates `~/claude-tester` with:
- `CLAUDE.md`, your standing instruction that `HANDOFF-BRIEF` sessions are tests you want run;
- `.claude/settings.json`, which pre-allows the Claude in Chrome tools (no browser permission prompts) and denies file edits;
- `.claude/skills/browser-tester`.

Serving a dedicated folder rather than your home directory keeps the trust prompt saved and keeps testers away from your files. Leave the terminal running. It shows up to lead agents as a `bridge` environment named `<host>:<user>:<id>`.

### 2. Give the lead agent the `delegate-browser-test` skill

Plugins can't be installed in cloud sessions, so pick one of these:

- **Account skill (recommended: reaches cloud and local sessions).** Run `scripts/package-skills.sh`, then upload `dist/delegate-browser-test.zip`, and `dist/browser-tester.zip` too if you like, in claude.ai → Settings → Capabilities → Skills.
- **Project skill.** Copy `skills/delegate-browser-test` into the repo you're working on as `.claude/skills/delegate-browser-test`. Sessions in this repo already have both skills via `.claude/skills/`.
- **Local plugin (desktop or CLI only).** `/plugin marketplace add crazymunch/CodeWork`, then `/plugin install codework-handoff@codework`.

### 3. First run from a cloud session

The first time a cloud lead starts a tester, it asks you to approve a **trusted-device** card in the Claude app. Approving permanently limits that lead session to your trusted devices.

## Using it

Tell the lead agent something like:

> Use delegate-browser-test to check that the signup flow on https://staging.example.com works end to end, signed in as my test account.

The lead writes the brief, starts the tester, checks in every 2 minutes, reads the report, fixes what it can, and runs up to 3 rounds. If the tester needs a login, it stops with `blocked: login`. Sign in once in that Chrome tab and the next round picks it up.

## Files

| Path | What |
|---|---|
| `skills/delegate-browser-test/` | Lead-side skill and the brief template |
| `skills/browser-tester/` | Tester-side skill and the report format |
| `tester-workspace/` | `CLAUDE.md` and settings copied to `~/claude-tester` |
| `scripts/install-tester.sh` | Sets up the tester workspace |
| `scripts/package-skills.sh` | Zips skills into `dist/` for account upload |
| `.claude-plugin/` | Plugin and marketplace manifests for local installs |
| `.claude/skills/` | Symlinks so sessions in this repo get both skills |

## Known limits

- **Polling, not push.** The lead learns of completion up to about 2 minutes late.
- **The tester computer must be awake** with the `remote-control` terminal running.
- **Auto mode may still ask before some browser actions.** The settings allow-list covers Claude in Chrome tools, but Chrome may ask once per site.
- **Screenshots stay on the tester computer.** The report carries text evidence only: exact on-screen text, console errors, failed requests.
