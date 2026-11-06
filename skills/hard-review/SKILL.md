---
name: hard-review
description: Multi-tiered adversarial review skill combining read-only 5-stage EGM reviews for specifications, fresh-context specialized code-review subagents, Git baseline comparison, and programmatic verification across security, concurrency, traceability, and QA dimensions.
---

# Deep Hard-Review: Multi-Tiered Adversarial Audit Protocol

The `/hard-review` skill provides rigorous, independent, multi-tiered adversarial audits for software architectures, implementation plans, and source code. It operates under a strict read-only invariant, deploying complementary review mechanisms: a 5-stage Elephant-Goldfish Model (EGM) review for design specifications, fresh-context specialized subagents for codebases, Git baseline delta tracking, and independent programmatic verification tools.

Reference Guides:
- Detailed Audit Checklists: [Review Dimensions](references/review-dimensions.md)
- Defect Severity Rubric & Diff Remediation: [Finding Template](references/finding-template.md)

---

## 1. Core Invariants & Operating Boundaries

1. **Strict Read-Only Invariant**:
   - `/hard-review` is STRICTLY READ-ONLY on all reviewed source artifacts, repositories, database schemas, and documentation.
   - The review process must NEVER modify reviewed source artifacts, invoke automatic remediation, or use `egm-resolve` to mutate files.
   - Findings, diffs, and audit artifacts must ONLY be written to a separate designated review-report location (e.g., `audit-reports/HR-REPORT-[date].md` or agent workspace report directory).
   - Correction-and-re-audit cycles take place ONLY after the user or a separately authorized execution workflow applies fixes. A maximum of 2 to 3 re-audit cycles is permitted per review engagement.
2. **Detection Coverage vs. Absolute Immunity**:
   - The review maximizes detection coverage through complementary independent reviews, specialized subagent heuristics, and programmatic verification.
   - It does NOT claim absolute defect immunity or zero-defect guarantees.
   - Every review report must explicitly disclose coverage limitations, scope boundaries, uninvestigated areas, and unresolved uncertainties.
3. **Product Owner Release Gate**:
   - Completion of a hard-review audit does NOT constitute release approval or milestone advancement.
   - Releases, milestone sign-offs (e.g., Everly M0 approval or M1 unlock), and issue closures require explicit, written human Product Owner approval.
4. **Strict Language Policy**:
   - Zero Bengali Unicode characters (`U+0980` to `U+09FF`) allowed in audit logs, reports, findings, diffs, or comments. Standard English or Latin alphabets only.

---

## 2. Review Routing & Target Applicability

Prior to launching review subagents, `/hard-review` assesses the target artifact type:

| Target Artifact Type | Primary Review Protocol | Auxiliary Checks |
|---|---|---|
| **Design Specifications, Architecture Documents, Implementation Plans** | **5-Stage EGM Review** (read-only evaluation) | AST/Regex consistency, Markdown link checks, Unicode scan |
| **Source Code, Migrations, Application Packages** | **Specialized Fresh-Context Code-Review Subagents** | Build/type-check verification, automated test suites, Git baseline diff scan |
| **Hybrid (Spec + Code PRs)** | **Dual-Track Review**: 5-Stage EGM on specs + Specialized subagents on code | Full programmatic verification suite |
| **Unsuitable Targets (Binary files, generated assets)** | **Report EGM as Not Applicable** | Programmatic checksum and size verification only |

*Note*: If an artifact is purely source code, EGM is reported as not applicable rather than forcing or misrepresenting an EGM review.

---

## 3. Five-Stage EGM Review Protocol (Specification & Design Targets)

When auditing design specifications, architectural documents, or implementation plans, `/hard-review` executes the 5-stage EGM review protocol using the exact registered persona names from the EGM plugin.

### Exact Registered EGM Reviewer Personas:
- **Step 5 — Initial Strategic Review**: `egm-zoom-out`
  - *Focus*: High-altitude simplicity, scope sanity, architectural minimalism, YAGNI, and existing codebase reuse.
  - *Supplementary Persona Note*: `inventive_catalyst` may be noted only as an optional supplementary ideation persona; it is NOT part of the standard five-stage review protocol and is not registered in the EGM plugin.
- **Step 6 — Comprehension Test**: `egm-comprehension`
  - *Focus*: Naive reader audit with zero assumed institutional knowledge, flagging undefined terms, ambiguous acronyms, missing prerequisites, and comprehension gaps.
- **Step 7 — Critic Review**: Swarm of three distinct reviewers:
  - `egm-design` (*CRITICAL*: The registered frontmatter name is `egm-design`, NOT `egm-design-critic`): System architecture, scalability bottlenecks, failure modes, infrastructure economics, unmitigated risks.
  - `egm-structural`: Document structure, heading hierarchy, template compliance, visual symmetry.
  - `egm-style`: Brevity, technical precision, eliminating marketing fluff and passive voice.
- **Step 8 — Intermediate Zoom Out**: `egm-zoom-out`
  - *Focus*: Re-evaluates document coherence after critic feedback, ensuring proposed changes have not bloated or over-complicated the design.
- **Step 9 — Implementation Readiness**: Swarm of three distinct reviewers:
  - `egm-implementation-readiness`: Verifies execution steps are completely actionable, concrete, and leave zero design decisions to the implementer.
  - `egm-codebase-details`: Exhaustively checks that paths, library imports, function signatures, and data models match the actual codebase state.
  - `egm-style`: Final polish on clarity and precision.

### Read-Only EGM Evaluation Requirement:
- All 5 evaluation stages execute without invoking `egm-resolve`, auto-fix, or source file modifications.
- Findings from each stage are captured at resolution checkpoints.
- The review report must explicitly state:
  > **"Five-stage evaluation completed; resolution intentionally skipped under the read-only policy."**
  Under no circumstances may the review claim that remediation was completed.

### EGM Plugin Inspection & Fallback:
- Inspect plugin availability at `~/.gemini/config/plugins/egm/plugin.json`.
- If EGM is unavailable, explicitly report:
  `"EGM plugin unavailable. Executing structured native-subagent review fallback."`
- Spawn fresh-context native subagents mirroring the 5 evaluation dimensions.
- EGM review examines requirements and plans, but NEVER replaces independent technical verification.

---

## 4. Fresh-Context Specialized Code-Review Subagents

When auditing source code, `/hard-review` spawns up to three specialized fresh-context review subagents. Each operates independently with a dedicated domain mandate:

### Subagent 1: Security & Authorization Auditor
- **Row-Level Security (RLS)**: Audits multi-tenant database tables to ensure RLS is active (`ENABLE ROW LEVEL SECURITY`) and policies cover `SELECT`, `INSERT`, `UPDATE`, and `DELETE`.
- **Connection Role Privileges**: Verifies database connection strings and pools do NOT connect with superuser (`rolsuper`) or bypass-RLS (`rolbypassrls`) roles in production workflows.
- **IDOR (Insecure Direct Object Reference)**: Audits all API parameters, query strings, and payloads to ensure user/tenant ownership is strictly verified on every query.
- **Injection Attack Surfaces**: Inspects all queries, command executions, and templates for SQL injection, shell command injection, or Cross-Site Scripting (XSS).
- **Session & Secret Security**: Audits JWT validation, cookie security flags (`HttpOnly`, `Secure`), and checks for hardcoded credentials or sensitive data in logs.

### Subagent 2: QA & Concurrency Hunter
- **Race Conditions**: Audits asynchronous sequences, state transitions, counter increments, and read-modify-write patterns for TOCTOU vulnerabilities.
- **Row-Level Locking**: Verifies that concurrent status changes or inventory/balance deductions utilize row-level locks (`SELECT ... FOR UPDATE`) or optimistic version checks.
- **Transaction Boundaries**: Ensures multi-record mutations are wrapped in explicit database transactions, and side-effects (e.g., outbound API calls) occur after commit.
- **Lifecycle & State Transitions**: Verifies state machines strictly reject invalid state jumps and that idempotent retry logic safely handles duplicate requests.
- **Timezone & Date Edge Cases**: Audits UTC storage normalization, leap year handling, daylight saving time shifts, and epoch conversions.

### Subagent 3: Completeness & Traceability Verifier
- **100% Bidirectional Traceability**: Audits bidirectional traceability across all in-scope and applicable requirements, acceptance criteria, test IDs, and domain invariants.
- **Missing Mappings**: Flags any unmapped requirement or unverified acceptance criterion as a defect.
- **Explicit N/A Handling**: Where an artifact type or relationship does not apply, requires explicit `N/A` notation accompanied by technical rationale.
- **Zero Hallucination Rule**: Strictly prohibits inventing requirements, test IDs, or invariants not present in authoritative project specifications.

---

## 5. Programmatic Verification Tools & Git Baseline

Programmatic verification provides objective, reproducible evidence that complements human and subagent reviews.

### 1. Git Baseline Capture & Accidental Write Detection
Before conducting any review activities:
1. Capture the initial Git status and porcelain diff as the baseline:
   ```bash
   git status --porcelain=v1 > /tmp/git-baseline.txt
   git diff > /tmp/git-diff-baseline.patch
   ```
2. Upon concluding the review, compare current Git status against `/tmp/git-baseline.txt`.
3. Distinguish:
   - Pre-existing uncommitted changes (present in initial baseline).
   - Designated review-report outputs (written strictly to designated report directories).
   - Unexpected writes or mutations (STRICTLY PROHIBITED).
4. Never claim "zero accidental writes" without a verified Git baseline comparison. All Git inspection commands must remain strictly read-only (`git status`, `git diff`, `git log`; never `git add`, `git commit`, `git checkout`).

### 2. Independent Technical Verification
The Main Agent directly runs project verification commands:
- **Build Verification**: Execute project compiler or build pipeline.
- **Type Checking**: Run type validation (`tsc --noEmit`, `mypy`).
- **Automated Tests**: Execute automated test suite (`pytest`, `npm test`, `cargo test`).

### 3. Scripted AST/Regex Metric Reconciliation
- Run cross-document regex/AST scripts to verify consistent version numbers, requirement IDs, entity schema names, and configuration variables across code, specs, and tests.

### 4. Automated Bengali Unicode Scanner
- Run a targeted Unicode scanner across all target, modified, and created files:
  ```python
  import re, glob
  # Scan for Bengali Unicode block U+0980 to U+09FF
  matches = re.findall(r"[\u0980-\u09FF]", content)
  assert len(matches) == 0, f"Violation: {len(matches)} Bengali characters found"
  ```
- Any detected Bengali characters constitute an immediate Blocker defect.

### 5. Markdown Reference & File Link Validation
- Programmatically verify that all Markdown links, relative file paths, and reference documents exist and resolve to valid filesystem targets.

---

## 6. Audit Execution Workflow

```
[Step 1: Baseline Capture] (Capture Git status & diff baseline)
          │
          ▼
[Step 2: Target Assessment] (Evaluate Target: Spec vs Code vs Hybrid)
          │
          ├───────────────────────────────────┬─────────────────────────────────┐
          ▼                                   ▼                                 ▼
   [Specification]                          [Code]                          [Hybrid]
 5-Stage EGM Review                 Specialized Subagents             Dual-Track Review
 (Zoom-Out, Comprehension,        (Security/RLS, QA/Concurrency,      (EGM + Subagents)
  Critic, Zoom-Out, Readiness)     Traceability Verifier)
          │                                   │                                 │
          └───────────────────────────────────┴─────────────────────────────────┘
                                              │
                                              ▼
[Step 3: Programmatic Verification] (Build, Tests, Types, AST Scan, Unicode Scan, Link Check)
                                              │
                                              ▼
[Step 4: Git Baseline Verification] (Verify zero accidental source mutations against baseline)
                                              │
                                              ▼
[Step 5: Finding Synthesis & Matrix] (Classify defects: Blocker, High, Medium, Low, Advisory)
                                              │
                                              ▼
[Step 6: Audit Report & PO Gate] (Publish report to designated location, enforce PO Gate)
```

---

## 7. Re-Audit Cycle Limitations

1. When defects are identified, `/hard-review` produces concrete diff remediations in the audit report.
2. The hard-review workflow terminates without applying changes.
3. Once the user or authorized development workflow applies fixes:
   - A re-audit may be triggered to verify resolution of reported findings.
   - Maximum of **2 to 3 re-audit cycles** permitted per engagement to prevent infinite audit-remediation loops.
   - If Blocker or High severity defects persist after 3 cycles, the audit status is set to `BLOCKED` and escalated directly to the human Product Owner.

---

## 8. Product Owner Release Gate

Every audit report generated under `/hard-review` concludes with the formal Product Owner Release Gate block defined in [Finding Template](references/finding-template.md). No release, deployment, or milestone advancement may proceed without formal human PO sign-off.
