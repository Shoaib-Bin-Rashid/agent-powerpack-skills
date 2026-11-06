# Hard-Review Dimensions & Audit Checklists

This document provides exhaustive, multi-dimensional audit checklists for adversarial, read-only code and specification audits under `/hard-review`. Auditors and specialized subagents must systematically evaluate target artifacts against each dimension below.

---

## Dimension 1: Requirement Completeness & Bidirectional Traceability

Every engineering deliverable must maintain airtight, verifiable traceability from high-level user requirements down to code lines and automated test cases.

### Audit Checklist:
- [ ] **100% Bidirectional Traceability**:
  - Forward: Every user story, SRS requirement, and acceptance criterion (AC) maps to at least one concrete architectural component, code implementation, and automated test ID.
  - Backward: Every implemented feature, endpoint, and test ID traces back to an approved, in-scope requirement or architectural decision record (ADR).
- [ ] **No Invented Requirements or Test IDs**:
  - Auditors must verify that requirements, test IDs, or acceptance criteria are NOT fabricated, hallucinated, or assumed.
  - If a specification does not define a requirement or test ID, it must NOT be invented in code or tests.
- [ ] **Explicit N/A Handling with Rationale**:
  - Where a specific dimension, artifact type, or relationship does not apply to the target scope, it must be explicitly labeled `N/A` accompanied by clear technical rationale (e.g., `"RLS Check: N/A — System is an offline CLI utility with no database persistence"`).
  - Silent omission of checklist items is prohibited.
- [ ] **Acceptance Criteria Verification**:
  - Are all edge cases and boundary conditions specified in the ACs explicitly verified in automated tests?
  - Are acceptance thresholds (e.g., latency, error rates, throughput) measurable and backed by tests?
- [ ] **Domain Invariant Enforcement**:
  - Are core domain invariants (e.g., non-negative balances, immutable audit logs, valid status transitions) enforced at both the domain model level and the database/storage layer?

---

## Dimension 2: System Architecture & Design Integrity

Evaluates component coupling, system boundaries, separation of concerns, and architectural consistency.

### Audit Checklist:
- [ ] **Modularity & Coupling**:
  - Are module boundaries cleanly separated with explicit interface contracts?
  - Are there circular dependencies between packages, modules, or services?
- [ ] **Single Source of Truth (SSOT)**:
  - Is state, configuration, or business logic duplicated across multiple files or layers?
  - Are data structures normalized with single points of authority?
- [ ] **Configuration vs. Code Separation**:
  - Are environment-specific variables, API endpoints, credentials, and tuning parameters externalized from application logic?
- [ ] **Error Propagation & Failure Domains**:
  - Are exceptions caught at appropriate architectural boundaries without silent swallowing (`except: pass` or empty catch blocks)?
  - Do errors contain sufficient contextual information for observability without exposing sensitive internal stack traces to clients?
  - Are subsystem failures isolated so they do not cascade across the entire platform?

---

## Dimension 3: Security, Authorization & Data Protection

Rigorous inspection of authentication, authorization policies, injection vectors, and data security.

### Audit Checklist:
- [ ] **Row-Level Security (RLS) Policies**:
  - Are PostgreSQL/Supabase RLS policies enabled on ALL multi-tenant tables (`ALTER TABLE ... ENABLE ROW LEVEL SECURITY`)?
  - Do RLS policies cover all operations (`SELECT`, `INSERT`, `UPDATE`, `DELETE`) with appropriate `USING` and `WITH CHECK` clauses?
- [ ] **Connection Role Privileges**:
  - Verify application database connections do NOT run under superuser roles (`rolsuper`) or roles with `rolbypassrls` enabled in production paths.
  - Are connection credentials restricted to least-privilege roles?
- [ ] **Insecure Direct Object Reference (IDOR)**:
  - Do API routes verify that the authenticated tenant/user owns or is explicitly authorized to access the requested resource ID (e.g., checking `tenant_id` or `user_id` on every query, not relying on unverified URL parameters)?
- [ ] **Injection Attack Surfaces**:
  - **SQL Injection**: Are all database queries parameterized or constructed using safe ORM/query builder abstractions? Zero string concatenation or raw formatting into SQL.
  - **Command Injection**: Are shell executions avoided or strictly escaped using argument arrays without shell interpolation (`execFile` vs `exec`, `subprocess.run(["cmd", arg])` vs `shell=True`)?
  - **XSS / Content Injection**: Are user-supplied inputs sanitized, escaped, and validated before rendering in HTML, Markdown, or templates?
- [ ] **Session & Token Security**:
  - Are JWTs or session tokens validated for expiration (`exp`), signature, issuer (`iss`), and audience (`aud`)?
  - Are tokens transmitted securely (e.g., `HttpOnly`, `Secure`, `SameSite` cookie flags)?
- [ ] **Secret Leakage & Logging**:
  - Are API keys, passwords, database URLs, or private tokens hardcoded in source files, commit history, or test fixtures?
  - Are sensitive values masked or excluded from application loggers and error telemetry?

---

## Dimension 4: Concurrency, Transactions & Race Conditions

Evaluates safety under concurrent execution, distributed operations, and asynchronous lifecycles.

### Audit Checklist:
- [ ] **Race Conditions & Critical Sections**:
  - Are shared mutable resources protected by appropriate synchronization primitives or database locks?
  - Are read-modify-write patterns protected against Time-of-Check to Time-of-Use (TOCTOU) race conditions?
- [ ] **Row-Level Locking & Optimistic Concurrency**:
  - Are database updates that depend on current balances, statuses, or counters protected via row-level locks (e.g., `SELECT ... FOR UPDATE`) or optimistic version checks (`WHERE version = :expected_version`)?
- [ ] **Transaction Boundaries & Atomicity**:
  - Are multi-table or multi-entity mutations wrapped in explicit ACID transactions?
  - Are side effects (e.g., sending emails, external API webhooks) placed AFTER transaction commit to avoid orphan side effects on transaction rollback?
- [ ] **Lifecycle State Transitions**:
  - Are finite state machine (FSM) transitions strictly validated (e.g., preventing transitions from `Cancelled` to `Completed`)?
  - Are status updates idempotent to gracefully handle duplicate network requests or retries?
- [ ] **Date, Time & Timezone Handling**:
  - Are all timestamps stored in UTC (ISO 8601 or epoch milliseconds)?
  - Are daylight saving time (DST) transitions, leap years, and month boundary calculations handled correctly using standard date libraries?
- [ ] **Subagent Write-Isolation Invariant**:
  - Verify that parallel engineering or review workflows never produce concurrent writes to the same file or database schema.

---

## Dimension 5: QA, Test Coverage & Verification Rigor

Evaluates whether tests genuinely verify behavior and handle failure scenarios rather than providing superficial coverage.

### Audit Checklist:
- [ ] **Behavioral vs. Implementation Testing**:
  - Do tests assert external behavior, contract outputs, and state transitions, or do they test brittle private implementation details?
- [ ] **Edge Case & Boundary Coverage**:
  - Are boundary values tested: null/None inputs, empty collections, zero values, maximum integer limits, oversized payloads, unicode extremes?
- [ ] **Negative & Failure Path Testing**:
  - Do tests verify that unauthorized requests, invalid inputs, network timeouts, and database disconnections fail safely with appropriate error codes?
- [ ] **Over-Mocking Audit**:
  - Are critical persistence constraints, foreign key cascades, unique indexes, or transaction rollbacks masked by over-simplified mocks?
  - Do integration tests exercise genuine database and component interactions where critical?
- [ ] **Test Determinism & Flakiness**:
  - Are tests deterministic, free of arbitrary `sleep` timeouts, race conditions, or reliance on execution order?
- [ ] **Programmatic Verification Compliance**:
  - Does the build pass cleanly with zero compiler warnings?
  - Does the type checker pass with zero errors (`tsc`, `mypy`)?
  - Does the linter pass with zero violations?
  - Does the automated Unicode scan confirm zero Bengali Unicode characters (`U+0980` to `U+09FF`)?
