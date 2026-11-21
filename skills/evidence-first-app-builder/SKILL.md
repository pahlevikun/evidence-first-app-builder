---
name: evidence-first-app-builder
description: Plan, design and build a new mobile or desktop app with an evidence-first method - research before code, a stack chosen from requirements, contract-tested core logic, numbered checklists ticked only with proof, design done before app screens, and atomic semantic commits.
---

# Evidence-first app builder

A step-by-step method for taking an app from idea to release-ready. It covers research, planning, architecture, design, implementation, testing, documentation and commits. It was distilled from a real multi-platform project built this way and is written to be reused for any app.

The method is fixed. The stack is not. Choose the stack from the requirements (section 3).

**The heart of the method is docs and design before execution.** Most of the value comes from three things done before code: planning the features (section 5), building the design file in FigCraft (section 9), and writing the handoff that ties every screen to real logic. Code is the last step of a feature, not the first.

## The docs-and-design gate (hard rule)

No feature code is written until, for that feature:
1. It has an F-id in a feature study with what, why, how, options with licences, the module it lands in, its interface, and its test recipe (5.7).
2. It is in the priority matrix and the checklist with a step number (5.8, 7).
3. It has a row in the feature -> screen -> calls map, its journeys, and its states (9.2).
4. Its screens exist in the design file, in both themes, with components from the library, and are in the handoff and the journey manifest (9.3-9.6).
5. The owner has accepted the scope (5.6).

The only code allowed before the gate is a spike that answers a question the docs cannot (phase 1), and the spike's result goes back into the docs.

---

## 0. When to use

Use when starting a new app, or continuing one built with this method.
Do not use for one-off scripts, or for a repo with its own established conventions (follow those).

## 1. Principles

1. **Research before code.** Competitor study, feature study and a sharpened brief come before the first module. Every claim cites a source and a date. Your own reading is marked "inference".
2. **Requirements pick the stack.** Write the requirements first, then choose the stack in an ADR. A shared native core is a choice for specific needs, not a default.
3. **Logic apart from UI.** Domain logic lives in a module with no UI, no platform APIs and no user-facing strings. It returns data and typed codes. The UI layer owns screens, permissions, storage, billing and sharing.
4. **Ports for anything swappable.** A platform service, an ML model, a third-party SDK or a file format sits behind an interface. The core owns the flow. The port only does the swappable part.
5. **Contracts are versioned files.** Every persisted or exchanged format gets a schema and a test that fails when code and schema drift. Optional additions keep the version. Renames, removals and meaning changes bump it, and readers migrate old files.
6. **Numbers, not opinions.** Quality bars (accuracy, size, latency, memory, tap count, network calls) are written up front and measured by a scorer. A default changes only when it beats the old one on agreed gates. Desktop numbers are not phone numbers.
7. **One numbered checklist is the completion contract.** A step is ticked only with evidence written next to it. Gaps and limits are written down, never hidden.
8. **Decisions are ADRs.** Every non-obvious choice gets an ADR. It stays Proposed until the owner accepts it.
9. **Design before app screens.** Direction, then a design source of truth, then a handoff table, then journeys. Screens are built from frames, not redrawn.
10. **Atomic semantic commits.** One concern per commit, conventional prefix with a scope, plain subject, a body that says why. Every code commit passes format, lint and tests.

## 2. Repository layout

Adapt names to the stack. Keep the roles.

| Path | Role |
|---|---|
| `README.md` | One paragraph on the product, layout table, the 3 commands to test it, "Read next" links |
| `core/` | Domain logic and its tests (shared core, or per-platform domain modules) |
| `sdk/` or `packages/` | Packaging of the core for each app (only when the core is shared) |
| `contract/` | Schemas and shared data both apps read: formats, feature/tier table, locales, remote config keys. README states the versioning rule |
| `tools/` | Dev-only scripts: model or asset fetch, fixture generators, evaluation scorers, device proof scripts |
| `fixtures/` | Deterministic test inputs with a `truth.json`. Downloaded sets are gitignored |
| `design/` | Direction doc, handoff, journeys, coverage audit, tokens, brand generator, design source file and previews, research notes |
| `docs/` | Numbered studies and plans, `CHECKLIST*.md`, `adr/`, `plans/`, `spikes/`, `research/`, `guides/`, `architecture/` |
| `apps/<platform>/` | Created only after design and app spec are done |

Gitignore from day 1: build output, generated bindings or code, downloaded models and datasets, evaluation runs (`out/`), virtual envs, caches, reports.

Large binaries are never committed. A script fetches them, pinned by version and sha256.

## 3. Choosing the stack (ADR 0001)

Write the requirements, then pick. Typical outcomes:

| Requirement | Suggested shape |
|---|---|
| One app, one platform, normal CRUD | Native app with a pure domain module inside it |
| iOS + Android, logic is ordinary business rules | Kotlin Multiplatform shared domain, or two native apps sharing `contract/` |
| iOS + Android, heavy compute (image, ML, crypto, parsing) that must behave identically and run offline | Shared native core (Rust or C++) with generated bindings (e.g. UniFFI), Android NDK, iOS static library |
| Web + mobile | Shared TypeScript domain package (use pnpm), native or web UI per surface |
| Desktop tool | Single binary preferred, zero install |

Rules for the decision:
- List candidates with licence, binary size, speed, accuracy, team skill, build complexity.
- Spike the riskiest candidate on every target before accepting (section 4, phase 1).
- If a shared native core is chosen: generated bindings only (no hand-written glue), one runtime per process for heavy engines, and package tests on each platform.
- Python or other dev tools never link the app. They talk to it through files and a CLI.

## 4. Phases, step by step

Each phase ends with its docs and checklist ticks committed.

### Phase 0. Brief and research (docs only)
1. `docs/00-platform-approach.md`: options per platform, dated constraints found.
2. `docs/01-competitor-study.md`: table *App | Free tier | Paid | Paywalled*. Per competitor: Features, Complaints (from reviews), **Take**, **Skip**. End with "Our position".
3. `docs/02-core-approach.md`: candidates for the hard part, compared on licence, size, speed, accuracy.
4. `docs/03-build-plan.md`, opening with **0. Sharpened brief** (section 5.3), then **Definition of done** as *# | Criterion | Bar | Checked by* (mark unmeasured bars "tune"), milestones that each end in a check a third party can run, spikes, and open items for the owner (name, minimum OS, pricing).
5. Feature studies (`04-`, `06-`, ...): F-numbered features with what/why, module, function signatures, algorithm, interface shape, licence of any model, and **one test recipe per feature** (section 6).

### Phase 0b. Feature planning and design (before any feature code)
- Feature studies, priority matrix and checklist (sections 5.7, 5.8, 7).
- Design study, direction, feature -> screen map, journeys, states, IX, then the FigCraft file, critique, accessibility pass and handoff (section 9).
- Product plan and free/paid boundary early, because it changes screens (phase 6 notes).
- A design stage is done when another agent could build the apps from the file and the handoff without asking questions.

### Phase 1. Spike the unknowns
- Prove the riskiest thing end to end on every target (desktop, iOS simulator, Android emulator, browser) before building more.
- Write `docs/spikes/s0-<topic>.md` (template in 5.4).
- Write ADR 0001 from what the spike proved.

### Phase 2. Fundamentals as vertical slices
- Write the plan file (template in 5.2) and the master checklist (section 7).
- First commits: `chore(repo)` gitignore, `chore(tools)` pinned asset fetch, `feat(core)` first modules, `feat(cli)` desktop runner, `feat(bindings)` if any, `chore(eval)` scorer, `chore(mobile)` device proof, then docs.

### Phase 3. Improve with measurement
- Baseline report first. Then candidate vs baseline with explicit gates (e.g. "golden exact, errors no worse, device time at most 2x").
- Sweep thresholds, pin the chosen value in config, add a test that pins it. Record surprises as **Found** and limits as **Gap**.

### Phase 4. Capabilities, one slice per feature
- Repeat the slice recipe (section 6) in checklist order.
- Cut scope on purpose. The owner sets scope. Deferred steps move to the next checklist with their number, never silently dropped.

### Phase 5. Packaging
- Package the core for each app with tests that call every new public entry on the simulator, emulator or browser.
- Optional add-ons (third-party SDKs, extra models) ship as separate packages.

### Phase 6. Product, monetisation, design
- Product plan: "Recommendation in one page" first, then tiers, prices, trial, and what is never paywalled. The free/paid boundary lives in `contract/features.json`.
- Sensible defaults: generous free core, no ads, no watermark, no forced account, yearly + lifetime plans, a trial reminder before charging, no dark patterns.
- Extend the design file with new pages for new feature groups (section 9.7), never by redrawing old pages.

### Phase 7. App spec and platform checklists
- `docs/app-spec.md`: v1 allowlist *Ships in v1 | Later*, feature IDs, screens and routes, content model, purchase recovery, telemetry (consent-based, error taxonomy), security, architecture, build environments (staging, production), accessibility and localisation, test gates, platform parity rules, open items.
- Per platform: README, architecture diagram (UI, domain, data, core), build variants, telemetry setup, running-and-testing.
- `CHECKLIST-<PLATFORM>.md` per platform with the same meaning per step. Never copy a tick across platforms. `CHECKLIST-RELEASE.md` is the go/no-go with evidence for every platform.
- App architecture default: UI, then domain use cases, then repositories, then data adapters and the core. Presentation calls use cases only. Domain imports no platform or vendor SDK. Errors are mapped once at the data boundary. About 80% coverage on domain, data and presentation logic.

### Phase 8. Apps
- Build each screen from its handoff frame, in checklist order, against the real core.
- A step is done when it works on simulator or emulator, in every launch language, light and dark, with screen-reader labels, and its states match the design.

## 5. Planning in depth

### 5.1 Planning documents in order
| Doc | Purpose | Must contain |
|---|---|---|
| Platform approach | Options | options x constraints, dated facts, recommendation |
| Competitor study | Market | pricing table, Features / Complaints / Take / Skip, our position |
| Core approach | Hard part | candidates compared, why one wins |
| Build plan | Brief and done | sharpened brief, rewritten prompt, DoD table, milestones, spikes, open items |
| Feature studies | What to build | F-ids, signatures, algorithms, test recipe per feature |
| Architecture | Map | diagram, ownership table, dependency direction |
| Product plan | Business | one-page recommendation, tiers, prices |
| App spec | Ship scope | allowlist, routes, content model, recovery, telemetry, security, parity, gates |

### 5.2 Plan file template (`docs/plans/YYYY-MM-DD-<topic>.md`)
```
# <Topic> Implementation Plan
> Implement task by task with TDD (failing test first, then the smallest pass),
> prove each task with a fresh verification run, and commit atomically.

**Goal:** one sentence a user would understand.
**Architecture:** 3-5 lines: which module, which port, which contract.
**Tech stack:** pinned versions.

## Try it yourself (after Task N)
<3-line command block and what it prints or writes>

## Global constraints
- offline or online rules, licences, fallbacks, contract versioning,
  no sensitive data in logs, no UI in the core, device timing evidence

## Prerequisites (run once)
## File map   (path -> responsibility, Create or Modify)
## Slices     (slice -> tasks -> acceptance)

### Task 1: <name>
**Blocked by:** None | Task k
**Files:** Create: ... Modify: ... Test: ...
**Interfaces:** Produces: <exact types and signatures>. Consumes: ...
- [ ] Step 1: write the failing test (full code)
- [ ] Step 2: run it, expect FAIL with <message>
- [ ] Step 3: smallest implementation (full code)
- [ ] Step 4: run, expect PASS, then format and lint
- [ ] Step 5: commit `feat(scope): ...`
```
Rules: one commit per task. Each task names exact types so later tasks can consume them. Code in the plan is complete, never "...". Acceptance is a command with expected output.

### 5.3 Sharpened brief (section 0 of the build plan)
1. What a top team would add that was not asked for (a scorer, a fallback, a privacy gate).
2. Raw material to start from (datasets, models, open-source code, with licences).
3. Methods and tools (named algorithms, libraries, pinned versions).
4. What shows it is right, other than the builders (third-party validators, metrics, real devices).
5. The request rewritten as a precise spec.

### 5.4 Spike template (`docs/spikes/sN-<topic>.md`)
Question. Setup (versions, devices). Table *Check | Result | Evidence*. Timings labelled desktop, simulator, device. Sizes. Findings that shape the code. Decision, with the ADR link.

### 5.5 ADR template (`docs/adr/NNNN-<slug>.md`)
```
# NNNN. <Decision as a sentence>
Status: Proposed | Accepted by <owner> on YYYY-MM-DD | Superseded by NNNN
## Context       forces, constraints, numbers
## Options       option | pros | cons | licence | cost
## Decision      one paragraph
## Evidence      spike, benchmark, links
## Consequences  what gets easier, harder, what we must now do
```
Typical ADRs: stack and architecture, storage, telemetry, monetisation, each model or library with a licence question. A rejected option gets a note in `docs/research/<step>-<topic>.md` (gap, options, decision, revisit when).

### 5.6 Scoping with the owner
- Propose, do not ask open questions. Give a recommendation and 2-3 options.
- Record the owner's call with the date in the checklist gate rules.
- Mark steps that need the owner (a decision, a device, an account) as `(owner)`.

### 5.7 Feature study format (one section per feature)
```
### F<n>. <Feature name>: <sub-features>
- **What:** what the user sees and does (observed in competitors, or specified).
- **How:** how others do it, with sources (papers, engineering blogs, docs).
- **Options:** each with size, speed, accuracy and LICENCE (unknown = must check before use);
  always include the classic or platform option behind a port.
- **Build in the core:**
  1. module and its pure, testable logic
  2. port and its first implementation, and the upgrade path
  3. public interface shape (types, copy cost, threading)
  4. what the app does instead of the core
- **Accuracy and tests:** metric, new fixture group, sequence tests.
- **Phase:** where it lands in the checklist, and what it waits on.
```
Before the feature list, the study states the boundaries that shape every feature:
- **Offline and size budget**: what runs on device, the bundled budget, the optional pack budget, measured sizes of candidate models.
- **Platform limits**: store size limits, background limits, packaging rules.
- **Core boundary**: the core returns data and codes; every interaction, string and permission is the app's.
- **Ports list**: each swappable piece, its trait or interface, and who implements it.
- **Data model**: e.g. one original plus reversible edits, so every edit can be undone and re-rendered.

### 5.8 Priority matrix and phases
| Feature | User value | Effort | Risk | Model/licence | Depends on | Phase |
- Rank by value over effort, with risk and licence as blockers.
- Group into phases (C1, C2, ...) that each ship something testable.
- The matrix decides the checklist order. Record the owner's scope call next to it.

### 5.9 Build guide (after the matrix)
- Module map: path -> responsibility for every new module.
- Port contracts written out as real signatures.
- Per phase: data flow, algorithm steps, edge cases, test fixtures, and the exact public calls the design will name.
- The design's "core calls" column must use these exact names.

## 6. Vertical slice recipe (every core feature)

A feature is done only when all of these exist:
1. **Module** with table-driven unit tests.
2. **Fixtures**: a generator script writes deterministic inputs and `truth.json`. Two runs give the same hash. Real samples come from permissively licensed sets, pinned and gitignored.
3. **Metric and gate** in the evaluation tool, with a threshold flag. Outputs are read back by an independent tool where one exists (a separate parser, validator or renderer).
4. **CLI or dev runner** writing outputs to `out/` for eyeballing, with an integration test.
5. **Public interface**: records with named fields, typed error enums, money as decimal strings, no stringly-typed errors.
6. **Platform tests** calling the interface on simulator, emulator or browser.
7. **Guide entry** in `docs/guides/testing.md` (command, expected output) and an **architecture entry** (what and why, with a diagram).
8. **Checklist tick** with evidence: test counts, commands, numbers, commit SHAs, gaps.

Commit order for one slice:
```
feat(core): parse receipts into items, charges and a checked total
feat(cli): parse receipts from images or json with the dev cli
feat(bindings): expose receipt parsing with amounts as decimal strings
test(eval): gate the receipt parser against every locale baseline
docs(guide): explain how to parse receipts and run the locale gate
docs(architecture): outline receipt parsing and its gate
test(sdk): parse a sample receipt through the ios and android packages
docs(checklist): tick the receipt step with the gate results
```

## 7. Checklist format

```
# Master checklist: <from X to Y>

This file is the completion contract for the project.
**Gate rules:**
- Work the steps in number order. A step marked || runs alongside the one before it.
- A Deferred step is out of scope and does not block later steps. Scope set by <owner> on <date>: ...
- Tick a step only when it is done and its evidence is written next to it.
- A step marked (owner) needs the owner: a decision, a device or an account.
- Every code commit passes <format>, <lint with warnings as errors>, <tests>.

| Stage | Steps | What | Plan | Done when |

## Step by step
- [x] **7.** <what>. Evidence: <numbers, commands, files>. **Found:** <surprise>. **Gap:** <limit>.
- [ ] **13.** <what> (**Deferred**). Moved to `CHECKLIST-2.md` step 72.
```
- Continue in `CHECKLIST-2.md` when scope grows. Tag steps by layer (core, sdk, tools, adr, design, ios, android, web, owner).
- Country or legal rules cite an official source and a date. Say "compliant" only with validator evidence.
- Every market or locale in scope is covered by every feature that has locale rules.

## 8. Commits

- Format `type(scope): subject`. Types: `feat`, `fix`, `docs`, `test`, `refactor`, `perf`, `build`, `ci`, `chore`, `style`. Scopes are module or area names (`core`, `cli`, `bindings`, `sdk`, `eval`, `fixtures`, `design`, `adr`, `checklist`, `guide`, `architecture`, `ios`, `android`, `contract`).
- Subject: lowercase, imperative, describes the user-visible capability, about 60 characters, at most 72, no trailing period. Example: `feat(pdf): compress pdfs by preset or target size without growing them`.
- Body on most commits: 1-3 short paragraphs on why and the non-obvious facts. Example:
  > /Annots may be an indirect array. Reading it directly saw nothing and replaced the form widgets with the new stamps. It is now read through the reference.
- A follow-up fix names the commit it fixes, and the cause: "The type_complexity lint failed on the table in <sha>. A head pipe hid the failing exit code."
- Keep commits small (median about 2 files). Split a big working tree with a commit plan first: numbered *subject - files*, plus a "Not staged" list.
- Commits carry the human author. No bot co-author trailers unless the owner wants them.
- Never trust a piped or truncated gate. Check the real exit code.

## 9. Design in depth (FigCraft)

FigCraft is the design source of truth: an editable native design file driven through the FigCraft MCP or app, with variables, styles, components, frames and prototype links. The same structure works in Figma if FigCraft is not available.

### 9.1 Study first, draw last (written in `design/00-direction.md`)
Write findings under "What the references taught", one numbered subsection per step:
1. **Method**: the design method and how it will be applied. Take the method, not another project's style.
2. **Own product docs**: feature studies, architecture, the public interface, pack and unavailable states. List every capability the design must serve.
3. **Reference screenshots**: per screenshot, what works and what to leave. References teach craft. Never copy a competitor's logo, layout or look.
4. **Competitor design study**: for each app record capture/main flow, review and edit, export and share, onboarding and permission asks, paywall pressure, type, density, colour, motion, haptics. Take / Leave.
5. **Platform guidance**: HIG and Material 3 rules that bind the design (camera, sheets, Dynamic Type, back, safe areas). Note where the two apps should differ.

Then write **Direction** as decisions before any drawing:
- One-sentence direction and 4-6 visual principles.
- Anti-patterns rejected in review (e.g. a colour reserved for one signal used elsewhere, dense plain lists, overlapping cards).
- Tokens table for Light and Dark with **computed contrast** next to each text pair.
- Type scale per platform, shape, space, radius, elevation, motion tokens.

### 9.2 Features, screens and journeys (written before drawing)
- **Feature -> screen -> calls map**:

| Feature | Screen ids | Core calls |
|---|---|---|
| Capture with live outline | S2 Camera, S2a no page, S2b low light | `detectPage` per frame, `measureSharpness` |

Every capability in scope has a screen or a state. Every screen names the exact calls it uses (from the build guide, 5.9). Screen ids are short and stable (S0, S1, S1e, S2a ...).
- **Journeys**: J-ids with path and taps to done:

| # | Journey | Path | Taps to done |
|---|---|---|---|
| J2 | Main job | S2 -> S4 Keep -> S5 -> Share | 3 |

Always include first launch with permissions, the main job, a fix-a-mistake path, every optional pack download, offline with everything working, and permission denied with a working alternative.
- **States for every screen**: empty, loading/progress, success, partial, error with retry, offline, permission denied, pack unavailable, locked (paid), cancelled, recovery, and domain states (low light, blurry, hard input).
- **Interaction spec (IX)** table: *Moment | Interaction | Motion | Reduce Motion | Haptic | VoiceOver / TalkBack*. Give real numbers (durations in ms, scale, spring) and the exact announcement text.

### 9.3 FigCraft file structure (one page per concern)
| Page | Content |
|---|---|
| 00 Cover | Name slot, one-sentence direction, principles, anti-patterns, any naming warning |
| A Tokens | Colour variables in a collection with Light and Dark modes, number variables (spacing, radius, sizes), text styles, effects. Boards rendered in both modes to prove Dark resolves through variables |
| B Components | Icon components and UI components with text, instance-swap and variant properties |
| C Journeys | Each J-id as a connected flow with screen ids and tap counts |
| D Screens · iPhone | Every screen at 393 x 852 in Light, plus Dark copies and localised copies of the key screens |
| D2 Screens · Android | Material 3 adaptations at 412 x 915 where the platform differs; others are shared |
| E Motion & IX | Storyboards for the key moments with timing, Reduce Motion, haptics and screen-reader lines |
| F Platform surfaces | Share targets, quick actions, widgets, tablet and foldable layouts |
| G, H, I ... | One page per later feature group (tools, sign, business, paid surfaces) |
| V App journey | The wired review copy (9.5) |
| Z Before refresh | Editable old versions of rebuilt screens, kept as reference |

### 9.4 Building the file, step by step (each step is a checklist step)
1. Cover and direction.
2. Tokens: create the variable collections and modes first. No raw hex in frames; every colour, text style, spacing and radius is a variable or style with a code name.
3. Components: build each control once with properties, then use instances everywhere.
4. Journeys board.
5. Screens: iPhone first, then Android adaptations. Light, then Dark copies, then localised copies (pick the longest-string language to catch overflow).
6. Motion and IX storyboards.
7. Platform surfaces.
8. Prototype: wire the taps for every journey and add flow starts. List the wired taps in the handoff.
9. Export one preview PNG per page to `design/figcraft/previews/`.
10. **Critique pass**: hostile review scored on quality, originality, type, spacing, colour, hierarchy, interaction, accessibility, responsiveness. Fix, re-screenshot, record the fixes.
11. **Accessibility pass**: computed contrast (text >= 4.5:1 in both modes, critical overlays higher), touch targets measured (44 pt / 48 dp), labels and Reduce Motion specified for every control.
12. **Handoff doc** (9.6). The stage is done here.

Evidence for each tick names the page, frame ids, counts (e.g. "19 iPhone frames, 2 Android frames, 23 icons, 24 components") and the preview file.

### 9.5 Wired journey page and manifest (for review and for AI edits)
- One page (V) holds a connected copy of every state, grouped (launch, home, capture, tools, settings, paid, recovery), with a review launcher that jumps to any state. Original boards stay as references.
- `design/APP-JOURNEY.json` is the machine-readable manifest:
```json
{
  "page_id": 0, "page_name": "V App journey",
  "product": {"display_name": "", "application_id": ""},
  "canonical_edit_surface": "Edit the journey copy. Preserve node IDs and update this manifest after edits.",
  "screens": [{"key": "J001", "node_id": 0, "name": "Splash", "group": "01 Launch", "source_node_id": 0}],
  "flows":   [{"name": "00 Full first run", "start": 0, "description": ""}],
  "routes":  [{"from": 0, "control": 0, "label": "", "to": 0}],
  "validation": ["all_states_reachable_from_launcher", "each_state_can_return_home",
                 "original_reference_nodes_preserved", "asynchronous_outcomes_are_not_click_successes"],
  "runtime_gaps": ["store purchase and OS permission outcomes are illustrative"],
  "async_transitions": [{"from": 0, "to": 0, "outcome": "", "prototype": "inspect from launcher"}],
  "native_handoffs":   [{"screen": "J116", "action": "", "behavior": "native picker, cancel returns"}]
}
```
- `design/APP-JOURNEY.md` explains main paths, rules for AI edits, scope counts and prototype limits.
- Rules for edits: edit the V copy, keep keys and node ids stable, add new states with new keys (never renumber), revalidate parent/child integrity, route destinations, reachability and preserved sources after every edit.
- Asynchronous results (progress -> result) are not tappable successes. Record them in `async_transitions`. OS pickers, permissions and store sheets go in `native_handoffs`.
- Large extensions (e.g. backup, trash, purchase recovery) get their own handoff file with a table *Screen | Node | Purpose* and the native outcome contract.

### 9.6 Handoff doc (`design/HANDOFF.md`)
- Header: display name, app id, date, "read with" links, the file path, previews path, and "build from these frames, do not redraw them".
- Pages table.
- Prototype: flow starts and a table of wired taps *Tap | Goes to*.
- Screens table *Frame | Screen | States drawn | Core calls | Notes* with exact sizes and token names in the notes.
- Components and tokens with code names, accessibility notes, and **open items / known gaps**.

### 9.7 Extending the design for new features
- Add a section to the direction doc: markets and country variants, free/paid boundary in the UI, new feature -> screen -> calls rows, new journeys continuing the J numbering, states for every new screen, IX additions, form factors.
- Add one FigCraft page per feature group with its own preview. Country variants are separate frames.
- Visual refreshes keep the old screens on a "before" page and record the decisions in an audit doc (`UI-UX-AUDIT.md`: verdict, competitor principles with sources, file organisation, visual decisions).
- Coverage audit (`UI-COVERAGE.md`): what the file covers, gaps filled per pass as *Area | New or rebuilt UI*, and what a prototype cannot prove.

### 9.8 Brand
- Brand assets come from a script: one geometry table plus `design/identity/tokens.json` generate icon, wordmark, splash and platform kits. Never hand-edit generated assets.
- Offer 3 directions with a recommendation, marked "recommendation, not a decision". The owner chooses, then the name and identity are applied everywhere in the same pass (file, direction, handoff, product strings).
- Studies of inspiration (e.g. splash screens) are tables *App | What it does | Take | Leave* with source and date.

### 9.9 Design guardrails
- The design file is the single source of truth. Edit the canonical file, reopen it after outside edits, regenerate previews.
- A prototype route or a polished frame is not runtime evidence. Label it "design artifact, not a working app".
- Previews rendered with fallback fonts do not verify platform fonts. Mark those checks unverified until rendered on the target.
- Design every state, both themes, every launch language, large font scale, and RTL if in scope.
- No dead ends: a deferred feature has no tile, route or paid benefit.
- The free/paid boundary in the UI matches `contract/features.json`. Locked items say what unlocks them and never nag.
- Avoid generic stock icon sets and template looks. Aim for a bespoke identity with character.
- Never use a competitor's name or trademark for the product, even as a long-lived codename in shipped strings.

### 9.10 Design to app bridge
- Each screen implements one handoff frame. Journey keys become route names and test tags.
- Tokens are exported to code, never retyped.
- App checklist steps cite the frame id and a screenshot per theme and language.
- Design commits use scopes like `docs(design)`, `feat(design)`, `fix(design)`, `feat(figcraft)`, `feat(brand)`, e.g. `docs(design): map each screen to its states and core calls in the handoff`, `fix(design): raise tertiary text contrast to 4.5 to 1 in both modes`.

## 10. Writing style for docs

- Short declarative sentences, plain words. Tables over prose. One fact per list line.
- Every doc opens with a status and date line and "Related" links.
- Record who decided what and when: "Scope (owner, YYYY-MM-DD): ...".
- Separate facts from inference. Mark proposals as proposals.
- State limits plainly: "desktop numbers are not phone numbers", "a successful build does not pass a runtime gate".
- Keep context notes for long-running work (what was done, evidence commands, open items).

## 11. Guardrails

- Never claim done without evidence. Never tick a step from a prototype, a static review or a build alone.
- Never put UI strings, UI state or interaction in the core. Never fork core logic into an app.
- Never commit models, datasets, generated code, build output or secrets. Pin downloads by sha256.
- Never ship a model or library with an unclear or non-commercial licence. Record the decision and ship a classic fallback.
- Every learned or optional component has a fallback or a typed "unavailable" state. A missing optional pack never crashes. Set size budgets for bundled and optional assets.
- Never log sensitive data. Test data is synthetic.
- Never use a competitor's trademark as the product name.
- Never expose deferred features. A core capability does not mean the app feature ships.
- Unexpected errors surface as errors, never as "no result". A secondary engine's error is recorded and keeps the primary result.
- Ask the owner for: product name, scope cuts, pricing, devices and accounts, legal sign-off, brand direction, repo creation.
- Package managers: follow the owner's choice (for Node.js, pnpm).

## 12. Kick-off checklist for a new repo

1. Get the one-line idea, a working codename, markets and languages, platforms, and anything off-limits. Record them in the build plan's section 0.
2. Commit the gitignore and a README skeleton.
3. Write docs 00-03 and ADR 0001 for the stack (Proposed).
4. Spike the riskiest unknown on every target and write the spike doc.
5. Write feature studies, the priority matrix, `docs/CHECKLIST.md` with gate rules, and the product plan.
6. Design study, direction, maps, journeys, states, IX, then the FigCraft file, critique, accessibility pass and handoff.
7. Plan files in `docs/plans/`, then build vertical slices in step order, tick with evidence, add an ADR per decision.
8. Package, then app spec, platform checklists, release checklist. Only then `apps/`.

## 13. Self-check before handing back

- [ ] Docs 00-03 exist, and the build plan has a sharpened brief and a DoD table.
- [ ] The stack choice and every licence choice has an ADR or research note.
- [ ] `CHECKLIST.md` exists with gate rules, and every tick has evidence.
- [ ] Each core feature has module, fixtures, metric gate, runner, interface, platform tests, guide and architecture entry.
- [ ] Every feature passed the docs-and-design gate before its code.
- [ ] The FigCraft file has tokens as variables, components, every screen and state, previews, a critique and an accessibility pass, a handoff and a validated journey manifest.
- [ ] Commits are atomic and semantic, and every gate is green.
- [ ] Limits, gaps and deferred items are written down.
