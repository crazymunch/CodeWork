# Brief template

Copy everything between the lines into the `prompt` of `create_session`, with every `<…>` filled in. Keep the first line exactly as written: the tester recognises a brief by it.

---

HANDOFF-BRIEF v1
Run id: <run id>
From: <lead session id> on behalf of the account owner. The owner set this tester up to run these briefs unattended.

Use the browser-tester skill. If it is not loaded, follow the rules in this brief.

## Goal
<one sentence: what must be true when the test passes>

## Start
URL: <https://…>
Allowed domains: <example.com, auth.example.com>
Sign-in needed: <no | yes, as <account/role>: use the existing Chrome sign-in, never type a password>

## Steps
1. <action>, expect <observable result>
2. <action>, expect <observable result>
3. …

## Pass when
- <observable criterion>
- <observable criterion>

## Also capture
- Before step 1, check the browser console and recent requests once, so errors from the first page load are recorded. Then report console errors and requests that failed on each page.
- <anything else: exact text of an error banner, a value in a table, …>

## Limits
- Timebox: <10> minutes.
- Do not buy, pay, send email or messages, delete or change real data, or accept terms. <add any exceptions the owner allowed explicitly>
- Do not read or change files on this computer, and do not message or trigger other sessions.

## Finish
End your turn with the HANDOFF-REPORT block (format in the browser-tester skill) as your final message. The lead reads it from your transcript; do not send it anywhere.

---
