# Outputs and acceptance expectations

Paths below are destinations in the app repository, not in this skill bundle.
Start from the [templates](../SKILL.md#bundle-files). Replace placeholders before
approval. Evidence names the commit, date, environment, command or review
procedure, result and durable report path. Missing proof leaves a row open.

## Phase 0: brief and research

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Platform study | `docs/00-platform-approach.md` | Targets, constraints, options, recommendation, dated sources | Each target and minimum OS has an explicit assumption or owner decision | Vendor references and decision record |
| Competitor study | `docs/01-competitor-study.md` | Free/paid table, features, complaints, take/skip, position | Each claim is dated and sourced, inference labelled, lessons change planned scope | Listing/review URLs and access dates |
| Core approach | `docs/02-core-approach.md` | Candidates, licences, size, speed, accuracy, risk | Hardest unknowns have bounded spikes, no stack assumed | Comparison and spike links |
| Build plan | `docs/03-build-plan.md` | Sharpened brief, rewritten prompt, DoD bars, milestones, spikes, owner decisions | Every milestone has a runnable check, unmeasured bars say tune | Owner scope approval with date |
| Feature studies | `docs/04-feature-study.md` | F-ids, what/why/how, options/licences, module, signatures, tests | Every in-scope feature has normal, empty and error recipes | Source links and fixture plan |

## Phase 0b: feature planning and design

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Priority matrix and checklist | `docs/CHECKLIST.md` | Step, F-id, priority, dependencies, acceptance, proof | All in-scope features map to ordered steps, deferrals keep IDs | Scope sign-off and linked studies |
| Product plan | `docs/08-product-plan.md` | Recommendation, tiers, pricing assumptions, free boundary | Owner accepts the boundary before paywall screens | Dated decision, contract diff |
| Direction | `design/00-direction.md` | Source lessons, take/leave, principles, tokens, feature-screen-call map, journeys, states, IX | No unowned state or invented domain call remains | Review notes and coverage table |
| Design source and brand | `design/figcraft/<product>.figcraft`, `design/brand/` | Canonical page, components, themes, locale/adaptive states, approved brand recipe | All scoped states are editable, reviewed for accessibility and built from shared components | Node IDs, preview paths, critique and approval |
| Handoff and manifest | `design/HANDOFF.md`, `design/APP-JOURNEY.md`, `design/APP-JOURNEY.json` | Calls, states, motion/reduced motion, accessibility, routes, async/native boundaries, gaps | Another builder can implement without guessing, IDs resolve and entries reach every intended state | Route audit, frame review, owner approval |

**Docs-and-design gate:** F-id study, priority/checklist step, screen-call map,
journeys/states, both-theme frames, handoff/manifest and accepted scope must all
exist for the feature. Record a gate decision with links to each. A prototype
route is not proof of storage, permission, purchase or job success. Runtime gaps
may remain explicit implementation tasks, but design/spec gaps block the gate.

## Phase 1: spike unknowns

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Spike report | `docs/spikes/s0-<topic>.md` | Question, timebox, targets, setup, command, results, limits | Riskiest path runs on every selected target or is explicitly rejected | Raw sanitized logs, device/OS, measured output |
| Stack ADR | `docs/adr/0001-stack-choice.md` | Status, context, decision, evidence, consequences, alternatives | Owner accepts based on spike results, unsupported claims stay provisional | Approval date and spike links |

## Phase 2: fundamentals

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Task plan and architecture | `docs/plans/YYYY-MM-DD-<topic>.md`, `docs/05-architecture.md` | Goal, modules/ports, constraints, tasks, checks | Dependency direction and first runnable slice are clear | Plan-to-checklist links |
| Contracts and fixtures | `contract/`, `fixtures/<feature>/` | Schema/version policy, truth, provenance, licence | Drift and migration tests cover formats, fixtures are deterministic | Contract test output and fixture hashes |
| First vertical slice | Domain module, `tools/`, `docs/guides/` | Eight deliverables below | Full slice works through a real consumer | Test, scorer and target proof reports |

## Phase 3: improve with measurement

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Comparison report | `docs/research/<step>-<candidate>.md` | Baseline, corpus/version, candidate, thresholds, Found, Gap | Agreed gates select or reject the candidate, device timing stays distinct from host timing | Scorer command and archived baseline/candidate reports |
| Pinned choice | Runtime config and regression test in selected module | Selected value, rationale link, upgrade guard | A test detects accidental threshold/default changes | Test output and ADR update |

## Phase 4: capabilities, one vertical slice each

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Feature slice | Module + fixtures + scorer + CLI + public API + target tests + guide + checklist | F-id, input/output/error contract and eight deliverables | All eight exist, normal/empty/error behavior works, no unexplained gate failure | Exact checks, fixture report, per-target proof, guide output |
| Scope changes | `docs/CHECKLIST.md`, successor checklist | Old step, reason, destination, owner | Nothing disappears or gains a copied tick | Dated scope approval |

The eight deliverables are: (1) pure domain module and unit tests, (2) fixtures
and truth, (3) numerical metric gate, (4) dev CLI or equivalent runnable harness,
(5) public interface and contract tests, (6) real consumer proof on each selected
target, (7) testing guide with expected output, (8) checklist tick with evidence.
If a deliverable is inapplicable, record the reason and accepted equivalent.
Generated bindings are required only when the chosen architecture uses them.

## Phase 5: packaging

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Consumer packages | `sdk/<platform>/` or stack-native package | Setup, public API, assets, optional add-ons, smoke tests | Every new public entry is called on its target, missing assets fail safely | Simulator/emulator/browser test results, artifact size/hash |
| Packaging guide | `docs/<platform>/running-and-testing.md` | Versions, clean build, target selection, expected result | A clean consumer can reproduce the package proof | Commands, target/OS and sanitized logs |

## Phase 6: product, monetisation and extended design

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Tier contract and product plan | `contract/features.json`, `docs/08-product-plan.md` | Free/paid boundary, trial, recovery, prices, exclusions | Contract and UI agree, cancellation/expiry preserve user data | Owner decision and contract tests |
| Extended handoff | `design/HANDOFF.md`, journey manifest and source | New groups, billing/native states, copy, failure/retry | New feature groups pass the same design gate | Reviewed frames and route audit |

## Phase 7: app spec and platform checklists

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| App spec | `docs/09-app-spec.md` or `docs/app-spec.md` | v1 allowlist/later, routes, model, recovery, telemetry, security, environments, accessibility, localisation, parity | Each shipping promise maps to a feature and platform step | Accepted spec and traceability audit |
| Platform docs/checklists | `docs/<platform>/`, `docs/CHECKLIST-<PLATFORM>.md` | Architecture, variants, setup, ordered steps, evidence | Each platform has its own checks, no copied ticks | Independent build/test/device records |

## Phase 8: apps and release

| Artifact | Path | Required sections | Done when | Evidence |
|---|---|---|---|---|
| Implemented screens | `apps/<platform>/` | Handoff-backed UI, use cases, adapters, state tests | Real logic matches frames in launch languages, both themes and accessibility modes | UI tests and screenshots per relevant state/target |
| Coverage audit | `design/UI-COVERAGE.md`, `design/UI-UX-AUDIT.md` | Feature/frame/route/runtime mapping, gaps, severity | No unexplained missing state, known limits stated | Frame comparison and device review |
| Release decision | `docs/CHECKLIST-RELEASE.md` | Candidate, product/recovery, security/privacy, performance, signed artifacts, approvals, rollout/rollback | No blocking row open, every target proven, owner approves exact candidate | Commit/build/hash, device/OS, test reports, sign-offs |
| Operations guide | `docs/guides/operations.md` | Publish, observe, pause/rollback, support and recovery | Operator can recover without guessing or exposing secrets | Rehearsal record and approved release decision |

A build alone never passes runtime or visual gates. Release evidence must cover
normal, empty, invalid, canceled and resumed outcomes, process death, low storage,
permissions, data recovery, privacy traffic and purchases when applicable. Use
synthetic data. Keep credentials and personal content out of reports.
