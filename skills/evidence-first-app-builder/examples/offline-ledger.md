# Pocket Ledger: one feature through the gate

This is a fictional docs-and-design review, not a claim of shipped software or
real design assets. IDs and evidence paths illustrate a completed gate record.
Only F01 is accepted. Cloud sync, receipt capture and billing are out of scope.

## Feature study entry: F01 save an expense

- What/why: record an amount offline so it is available after restart.
- Priority: P0, master step 1. Scope accepted by product owner, 2026-06-01
  (fictional review record `docs/reviews/2026-06-01-scope.md`).
- Module: `apps/ios/Domain/Expenses`. UI owns copy and form state. A repository
  port owns persistence. Interface: `saveExpense(draft) -> Result<Entry, SaveError>`.
- How: validate currency and exact minor units, commit atomically using a stable
  operation ID, return `invalidAmount` or `storageUnavailable` without losing draft.
- Options/licences: use platform storage (SDK terms, verify for selected version)
  or SQLite (public domain, verify distribution). Platform storage chosen for
  the single-target v1, no engine dependency. This is an illustrative comparison.
- Recipe: 12.34 USD becomes 1234 minor units and survives restart. Blank amount
  returns `invalidAmount`, no write. Full storage preserves draft and retry uses
  the same operation ID. Interrupted commit reconciles before retry.

## ADR 0001: native domain module

Status: Accepted in this fictional scenario, product owner, 2026-06-01.
Context: one iOS target, offline CRUD, no heavy compute or shared binary need.
Decision: native app with pure domain module and a storage port.
Rejected: shared native core adds binding/build work without a current consumer.
Consequence: no Rust or NDK tooling. Revisit if another platform is approved.
Evidence: illustrative storage spike `docs/spikes/s0-storage.md`, restart and
interrupted-write checks on the selected simulator. Physical-device timing is
unmeasured and is not claimed by this design gate.

## Direction, handoff and states

Direction: quiet form, amount first, semantic contrast in both themes, no chart
before the first entry. Components: currency field, primary button, error banner.
Empty amount disables Save. Invalid input announces an inline error on J001.
Submission enters J002. Runtime success enters J003, failure enters J004.
Back/cancel returns to the preserved draft. All controls have labels and support
large text. Save announces progress, then success or the recoverable error.

| F-id / screen | Frames light / dark | Calls and states | Motion / accessibility | Evidence |
|---|---|---|---|---|
| F01 / S1, S2 | 101-104 / 201-204, canonical P1 | saveExpense; edit, pending, saved, failure | 150ms fade, instant with reduced motion; amount first | Fictional `design/previews/F01-review.png`, owner accepted |

The [journey snippet](offline-ledger-journey.json) is the complete small manifest
for these four states. Real storage outcomes remain runtime work, never clickable
success guarantees. The form, button and error frames are assumed present in the
fictional canonical file, not supplied as editable assets in this example.

## Gate checklist record

| Step | Status | Acceptance | Evidence |
|---|---|---|---|
| 1 | Done, fictional design gate only | F01 study, P0 matrix, states/calls, both-theme frames, handoff, manifest and accepted scope | This entry, ADR 0001, handoff above, linked manifest, fictional scope review and preview record dated 2026-06-01 |
| 2 | Open | Implement and prove save/restart/error recovery | No runtime evidence yet |

In a real project, missing frame assets or approval records would leave step 1
open. This example shows their expected record shape, not substitute evidence.
