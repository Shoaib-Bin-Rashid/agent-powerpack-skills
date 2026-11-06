# Hard-Review Finding Matrix & Defect Remediation Template

This document defines the standardized defect severity rubric, evidence format, finding matrix structure, and diff-based remediation template for all audits conducted under `/hard-review`.

---

## 1. Defect Severity Classification Rubric

Every finding discovered during an adversarial review must be assigned one of five standardized severity levels:

| Severity Level | Identifier | Criteria & Impact | Remediation SLA / Policy Gate |
|---|---|---|---|
| **Blocker** | `Sev-0` / Critical | Hard governance violations, security breaches (e.g., missing RLS, bypass roles, injection, remote code execution), data loss or corruption, broken builds, missing mandatory core requirements, unhandled concurrency races on financial/state data. | **Release Blocker**: Must be resolved before any release, milestone advancement, or merge. |
| **High** | `Sev-1` / High | Race conditions in secondary flows, missing authorization checks on non-critical endpoints, broken traceability on key acceptance criteria, architectural layering violations, unescaped user input surfaces, unhandled transaction rollbacks. | Must be addressed prior to final approval; requires explicit re-audit verification. |
| **Medium** | `Sev-2` / Medium | Edge case handling gaps (null/empty inputs, timezone/DST quirks), incomplete error propagation or swallowed exceptions, missing negative test cases, unaddressed non-functional requirements. | Recommended resolution before release; can be accepted with documented PO technical debt rationale. |
| **Low** | `Sev-3` / Low | Minor code style inconsistencies, documentation ambiguities, outdated comments, sub-optimal query formatting, minor dead code. | Clean up during routine maintenance or current development cycle. |
| **Advisory** | `Sev-4` / Info | Informational observations, architectural enhancement opportunities, performance optimization suggestions, future maintainability recommendations. | Informational only; does not block release or milestone sign-off. |

---

## 2. Standardized Finding Entry Format

Each finding must be documented using the following standardized template, ensuring full reproducibility and unambiguous remediation.

### Finding ID: `HR-[DIMENSION]-[INDEX]`
- **Severity**: `[Blocker | High | Medium | Low | Advisory]`
- **Dimension**: `[Completeness & Traceability | Architecture | Security & RLS | Concurrency & Transactions | QA & Verification]`
- **Target File**: `[Absolute or workspace-relative path]`
- **Line Range**: Lines `[StartLine]`–`[EndLine]`
- **Target Component / Function**: `[Class, function, or route name]`

#### 1. Verbatim Evidence
Direct quote of the offending code or specification snippet:
```[language]
// Exact lines from the source artifact
```

#### 2. Failure Scenario & Vulnerability Analysis
- **Trigger**: How the failure or exploit is triggered (e.g., concurrent requests from two sessions, input containing malicious SQL or XSS payload, edge-case null timestamp).
- **Mechanism**: Step-by-step trace of how the code fails or is exploited.
- **Impact**: Concrete impact on system integrity, security, data consistency, or compliance.

#### 3. Actionable Diff Remediation
Provide a minimal, complete drop-in unified diff resolving the defect:
```diff
--- a/[path/to/target/file]
+++ b/[path/to/target/file]
@@ -start,lines +start,lines @@
 context line
-offending code line
+remediated secure/robust code line
 context line
```

#### 4. Verification & Invalidation Condition
- **Verification Command**: Exact command (test, lint, script) to confirm the fix works.
- **Invalidation Condition**: What condition would prove the finding invalid or resolved.

---

## 3. Finding Matrix Table Format

Audits must summarize all findings in an executive summary table:

| Finding ID | Severity | Dimension | File & Lines | Summary Description | Status |
|---|---|---|---|---|---|
| `HR-SEC-001` | **Blocker** | Security & RLS | `src/db/users.ts:42-55` | Tenant query lacks RLS tenant_id filter; exposes IDOR | Open |
| `HR-CON-001` | **High** | Concurrency | `src/services/order.ts:88-102` | Balance check-then-deduct lacks `SELECT ... FOR UPDATE` row lock | Open |
| `HR-TRC-001` | **Medium** | Traceability | `tests/unit/auth.test.ts:1-20` | AC-003 edge case (expired token renewal) lacks test coverage | Open |

---

## 4. Product Owner Release Gate Block

At the conclusion of every hard-review audit report, the following governance release gate block must be included:

```markdown
---

## Product Owner Governance Release Gate

- **Audit Status**: [READY FOR REVIEW | DEFECTS OUTSTANDING | BLOCKED]
- **Blocker Count**: [N]
- **High Count**: [N]
- **Medium Count**: [N]
- **Low Count**: [N]
- **Advisory Count**: [N]

### Governance Invariants:
1. Hard-review execution is strictly read-only and does NOT mutate source code or automatically apply remediations.
2. The completion of this audit report does NOT constitute Product Owner sign-off, milestone advancement, or release approval.
3. For project Everly: Milestone M0 approval gate remains strictly active, GitHub Issue #6 remains OPEN, and Milestone M1 remains LOCKED until explicit human Product Owner sign-off is provided.

**Product Owner Formal Sign-Off**:
- [ ] Approved for Milestone Advancement / Production Release
- [ ] Rejected — Outstanding Blocker/High defects must be resolved and re-audited

Signer: _________________________ (Human Product Owner)
Date:   _________________________
```
