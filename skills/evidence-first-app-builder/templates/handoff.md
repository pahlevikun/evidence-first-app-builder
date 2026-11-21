# &lt;Product&gt; implementation handoff

Canonical source: &lt;file, page ID&gt;. Manifest: `APP-JOURNEY.json`.
Scope/version: &lt;F-ids, commit, owner approval/date&gt;.
Do not rebuild reference duplicates. Preserve stable journey keys and node IDs.

## Implement from here

| F-id / screen | Exact frame IDs, themes | States and calls | Motion / reduced motion | Accessibility and copy | Proof / runtime gaps |
|---|---|---|---|---|---|
| F01 / S1 Add entry | light 101, dark 201 | blank/invalid/saving/error; saveEntry | 150ms fade / instant | Amount label first, error announced | Preview reviewed, persistence not implemented |
| &lt;F-id/S-id&gt; | &lt;node IDs&gt; | &lt;states, signatures, owner&gt; | &lt;timing/fallback&gt; | &lt;focus, labels, strings&gt; | &lt;evidence/gaps&gt; |

## Runtime boundaries

| Journey state | Trigger | Runtime owner | Success / failure / cancel / resume |
|---|---|---|---|
| J002 Saving | Valid form submitted | Storage adapter | Commit to J003, failure to J004, retry keeps draft |
| &lt;J-key&gt; | &lt;event&gt; | &lt;adapter&gt; | &lt;outcomes and destination IDs&gt; |

## Validation

<Route/reachability audit, themes/locales/adaptive coverage, owner review, known
limits>. A clickable success example does not prove a completed runtime job.
