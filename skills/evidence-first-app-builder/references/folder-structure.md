# Repository structure

Use this as a north-star map, not a command to create empty folders. Keep the
evidence and design roles even when the stack puts source code elsewhere.

```text
README.md
docs/
  00-platform-approach.md
  01-competitor-study.md
  02-core-approach.md
  03-build-plan.md
  04-feature-study.md
  05-architecture.md
  08-product-plan.md
  09-app-spec.md
  CHECKLIST.md
  CHECKLIST-<PLATFORM>.md
  CHECKLIST-RELEASE.md
  adr/0001-stack-choice.md
  research/<step>-<question>.md
  plans/YYYY-MM-DD-<topic>.md
  spikes/s0-<topic>.md
  guides/testing-the-domain.md
  guides/operations.md
  architecture/OUTLINE.md
  <platform>/running-and-testing.md
  privacy/<integration>.md
design/
  00-direction.md
  HANDOFF.md
  APP-JOURNEY.md
  APP-JOURNEY.json
  UI-COVERAGE.md
  UI-UX-AUDIT.md
  figcraft/<product>.figcraft
  previews/
  identity/tokens.json
  brand/brief.md
  brand/build_brand.py
  brand/README.md
  research/<topic>.md
contract/
  README.md
  <entity>.schema.json
  features.json
  features.released.json
  locales/<locale>.json
fixtures/<feature>/truth.json
tools/
  eval/
  fixtures/
  mobile/
  scripts/
apps/<platform>/
core/                         # Or a stack-native domain/shared module
sdk/<platform>/               # Only if distributing a shared core
```

## Folder responsibilities

| Folder | Purpose and contents | Naming and ownership |
|---|---|---|
| `docs/` | Decision-ready studies, scope, architecture, master and release checklists | Number studies in reading order, `00-`, `01-`, etc. Numbers are stable, not progress percentages. Keep gaps when adding later studies. |
| `docs/adr/` | Context, decision, evidence, rejected options, consequences | Four-digit sequence, `0001-stack-choice.md`. Status is Proposed until accepted, with approver and date. Supersede rather than renumber. |
| `docs/research/` | Dated sources, licence checks, unresolved questions and findings | Prefix by checklist step when relevant, `<step>-<topic>.md`. Separate observed facts from inference. |
| `docs/plans/` | Task-level implementation plans and reproducible verification | `YYYY-MM-DD-<topic>.md`, linked from the master checklist. |
| `docs/spikes/` | Bounded experiments with target, command, result and decision | `s0-<topic>.md`, then `s1-...`. Record failures too. |
| `docs/guides/` | Setup, automated tests, manual fixture run, target proof, operations | `testing-the-<module>.md`, `<product>-operations.md`. Commands run from a stated directory. |
| `docs/<platform>/` | Platform README, architecture, build variants, integration setup, running and testing | Keep evidence independent per platform. `docs/architecture/` holds cross-platform diagrams. |
| `docs/privacy/` | Integration disclosures and observed traffic expectations | One file per integration. A draft is not legal approval. |
| `design/` | Direction, handoff, journey manifest and coverage/audit reports | Stable `F01` feature IDs, `S1` logical screens and `J001` journey-state keys. Record exact native node IDs separately. |
| `design/figcraft/` | Editable canonical design source and preserved reference boards | `<product>.figcraft`. Name the canonical page in the manifest. Never regenerate IDs just to tidy them. |
| `design/previews/` | Exported theme, locale and viewport review images | `<screen>-<state>-<theme>-<locale>.png`. The source may instead use `design/figcraft/previews/`, choose one path and link it consistently. |
| `design/identity/` | Semantic tokens, typography, platform mappings and licences | Machine-readable tokens plus a README explaining platform substitutions. |
| `design/brand/` | Brief, compared directions, approved recipe, generator and asset inventory | Keep generated icons, banners and previews traceable to an approved recipe. Font licences travel with fonts. |
| `design/research/` | Visual reference lessons and take/leave decisions | Topic names, source URLs and access dates. References are not layouts to copy. |
| `contract/` | Persisted/exchanged schemas, tier boundary, locale/config tables and released snapshots | `<entity>.schema.json`. README defines versioning, migration and drift tests. Only add config or pack manifests when used. |
| `fixtures/` | Small synthetic or licensed deterministic inputs and ground truth | Group by capability. `truth.json` names input, expected output, origin and licence. Ignore downloaded sets. |
| `tools/` | Dev-only scorers, fixture generators, pinned fetchers and target proof scripts | `eval/`, `fixtures/`, `mobile/`, `scripts/`. Add `models/`, `ffi/` or training tools only if needed. Runtime code does not import these. |
| `apps/` | UI, permissions, persistence adapters, billing and native handoffs | `apps/ios/`, `apps/android/`, `apps/web/`, `apps/desktop/` only for selected targets after their gate. |
| `core/`, shared module | Pure domain behavior and tests | No UI or platform SDK imports. Match the selected stack, not this directory spelling. |
| `sdk/` | Tested consumer packaging and generated bindings | Only for shared-core consumers. Ignore generated binaries and bindings. |

Checklist step numbers survive deferral. Link the old step to its destination
in `CHECKLIST-2.md` or a dated plan. Do not recycle F-ids or screen keys.

## Stack variants

| Stack chosen in ADR 0001 | Source shape | What stays conditional |
|---|---|---|
| Single native app | `apps/ios/` or `apps/android/`, with an internal pure domain module | No shared SDK or separate core workspace required. |
| Kotlin Multiplatform | `shared/` domain and tests, native apps under `apps/` | Platform adapters stay outside shared domain. No Rust or NDK requirement. |
| Shared Rust or C++ core | `core/`, generated bindings, `sdk/ios/`, `sdk/android/` | Choose only for proven cross-target compute needs. Android NDK and native packaging checks apply only here. |
| Web and mobile pnpm monorepo | `apps/web/`, `apps/mobile/`, `packages/domain/`, `packages/ui/` where truly shared | Use pnpm workspaces. Share contracts, not assumptions about native UI or permissions. |
| Desktop single binary | `apps/desktop/` plus domain module, or one package with separate domain sources | Document OS packaging and clean-machine launch. Avoid a service or installer unless requirements demand one. |

Ignore build products, evaluation runs under `out/`, caches, downloaded datasets,
models and local secrets. Fetch large assets by pinned version and checksum.
