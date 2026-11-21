# Testing &lt;module&gt; yourself

Run from &lt;repo root&gt;. Inputs must be synthetic or licensed, without personal data.

## Setup

&lt;Pinned tool versions, selected targets, asset fetch/checksums, offline behavior&gt;.
Install Rust or Android NDK only if the accepted architecture requires them.
For a Node stack, use pnpm commands and the repository's declared package scripts.

| Level | What it proves | Command / procedure | Expected output |
|---|---|---|---|
| Contract | Example journey JSON parses | `python3 -m json.tool design/APP-JOURNEY.json` | Formatted JSON and exit 0, not semantic validity |
| Unit | &lt;domain normal/empty/error&gt; | &lt;actual command&gt; | &lt;test count/result&gt; |
| Fixture | &lt;input to output&gt; | &lt;actual harness command&gt; | &lt;output path and metric bar&gt; |
| Consumer | &lt;public API on target&gt; | &lt;target command&gt; | &lt;asserted result&gt; |
| Device/UI | &lt;real flow and failure recovery&gt; | &lt;steps, device/OS&gt; | &lt;screens and preserved data&gt; |

## Try your own synthetic input

&lt;Three short steps, expected output, independent inspection method and cleanup&gt;.

## Failure and recovery

<Missing asset, invalid input, empty data, permission denial, interrupted write,
safe retry. State the typed error and what data must remain>.

## Evidence record

<Commit/build, date, tool versions, device/OS, exact commands, results, sanitized
logs/report paths, known gaps>. Host timing is not device timing.
