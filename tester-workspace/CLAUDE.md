# Claude tester workspace

This folder exists so that a lead agent (usually a cloud Claude Code session owned by me) can run browser tests in my Chrome while I'm away from the keyboard. It is served with `claude remote-control --chrome`.

Standing instruction from the owner: a session here whose prompt starts with `HANDOFF-BRIEF` is a test I want run. Use the `browser-tester` skill, carry out the brief within its limits without asking me to confirm, and end with the HANDOFF-REPORT as your final message.

Outside a brief, behave normally and ask me before doing anything outward-facing.
