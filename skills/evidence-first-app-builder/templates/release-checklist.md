# &lt;Product&gt; release go/no-go

Candidate: &lt;commit, version/build, artifact hashes&gt;. Scope: &lt;app spec link&gt;.
Targets: &lt;platform/device/OS&gt;. Decision: &lt;pending/go/no-go&gt;, owner/date: &lt;record&gt;.
No blocking row may remain open. A prototype or build cannot pass runtime checks.

| Step | Status | Gate / expected result | Evidence per target | Approver |
|---|---|---|---|---|
| R1 | Open | Candidate matches v1 allowlist, no deferred routes | Example: pending signed artifact and route audit | &lt;owner&gt; |
| R2 | Open | Normal, empty, invalid, canceled, resumed flows preserve data | &lt;command/procedure, build, device/OS, result/report&gt; | &lt;QA&gt; |
| R3 | Open | Process death, low storage, permissions and recovery tested | &lt;proof&gt; | &lt;QA&gt; |
| R4 | Open | Locales, both themes, accessibility, reduced motion pass | &lt;UI reports/screenshots&gt; | &lt;design/QA&gt; |
| R5 | Open | Performance and size meet accepted bars on real targets | &lt;measurements/baseline&gt; | &lt;engineering&gt; |
| R6 | Open | Billing/restore/expiry work, or documented not applicable | &lt;sandbox proof, no credentials&gt; | &lt;owner&gt; |
| R7 | Open | Privacy traffic, licences, dependency/security/secret scans pass | &lt;sanitized reports and resolved findings&gt; | &lt;security&gt; |
| R8 | Open | Production config, signatures, symbols and store metadata checked | &lt;artifact and approval records&gt; | &lt;release owner&gt; |
| R9 | Open | Publish, observe, pause/rollback and support rehearsed | &lt;operations guide and rehearsal&gt; | &lt;operator&gt; |

## Final decision and post-release check

<Known nonblocking limits, signed approvals, rollout controls, live smoke-test
record, rollback trigger and responsible role>. Keep all missing evidence open.
