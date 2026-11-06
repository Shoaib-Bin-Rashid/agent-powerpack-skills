---
name: teamform
description: Dynamic multi-agent team formation skill that analyzes task complexity, decomposes parallelizable work into 2-3 specialized native subagents with strict write-isolation, integrates code centrally, runs technical verification, and executes a central EGM loophole review before delivery.
---

# Teamform: Native Multi-Agent Decomposition & Orchestration

The `/teamform` skill provides structured multi-agent coordination for complex engineering tasks. The Main Agent acts as Lead Architect and Central Orchestrator, dynamically sizing the task, decomposing independent workstreams into 2 to 3 specialized native subagents, enforcing single-writer isolation, centrally integrating code changes, independently running technical verifications, and conducting a final loophole audit via the Elephant-Goldfish Model (EGM) or structured native fallback.

---

## 1. Core Principles & Governance Invariants

1. **No Forced Parallelization**: Small, sequential, or tightly coupled tasks must NEVER be forced into subagents. If a task touches a single file, is sequential by nature, or has high inter-dependency, the Main Agent executes it directly.
2. **Specialized Native Subagents**: When parallelizable, work is partitioned across 2 to 3 (maximum 4) specialized subagents (e.g., Subagent 1: Frontend/UI, Subagent 2: Backend/API/DB, Subagent 3: Research/Test Harness).
3. **Strict Write-Isolation**: Concurrent writes to the same file, directory scope, or database schema are strictly prohibited. Each subagent is assigned disjoint, mutually exclusive write paths.
4. **Central Integration & Independent Verification**: Subagents report findings, code patches, or modules back to the Main Agent. The Main Agent resolves conflicts, integrates code, and independently executes technical verifications (build, type check, automated tests).
5. **Central EGM Final Loophole Review**: Before final delivery, a central EGM review is executed to detect unaddressed requirements, edge cases, and design loopholes. If EGM is unavailable, a structured native-subagent review fallback is used.
6. **Product Owner Release Gate**: No release, protected status transition, milestone approval (such as Everly M0 approval or M1 unlock), or governance issue closure may occur without explicit written human Product Owner approval.
7. **Strict Language Policy**: Zero Bengali Unicode characters (`U+0980` to `U+09FF`) permitted across code, comments, reports, and documentation. Standard English or Latin-script Banglish only.

---

## 2. Seven-Phase Lifecycle

```
[Phase 1: Task Intake & Sizing]
       │
       ├─── Small / Sequential? ─────────► [Execute Directly in Main Context]
       │
       ▼ (Complex / Parallelizable)
[Phase 2: Decomposition & Dispatch] (2-3 Subagents, Disjoint Write Boundaries)
       │
       ▼
[Phase 3: Parallel Execution & Concurrency Cap] (Max 4 Concurrent, Read-Only Scans OK)
       │
       ▼
[Phase 4: Central Integration & Conflict Resolution] (Main Agent Merges Patches)
       │
       ▼
[Phase 5: Technical Verification] (Main Agent runs Build, Lint, Typecheck, Tests)
       │
       ▼
[Phase 6: Central EGM Final Review] (Loophole Audit / Structured Native Fallback)
       │
       ▼
[Phase 7: Delivery & Reporting] (Summary, Artifact Links, PO Sign-Off Gate)
```

---

### Phase 1: Task Intake & Complexity Evaluation

The Main Agent analyzes the user prompt and repository context:
- **Evaluation Criteria**:
  - File count: Will changes touch more than 3 distinct, loosely coupled files?
  - Domain separation: Can the work be cleanly partitioned into separate layers (e.g., UI vs. API vs. Test Harness)?
  - Dependency coupling: Are the changes sequential (Step B requires Step A's output) or parallel (Step A and Step B can run concurrently)?
- **Decision Rule**:
  - If sequential, tightly coupled, or ≤ 2 related files: **Execute directly in Main Agent context**. Do NOT invoke subagents.
  - If parallelizable and multi-component: Proceed to Phase 2.

---

### Phase 2: Decomposition & Subagent Dispatch

The Main Agent establishes precise architectural contracts and dispatches 2 to 3 specialized native subagents.

#### Standard Decomposition Archetypes:
- **Subagent 1 (Interface / Client / Presentation)**:
  - Scope: Frontend components, templates, client state, UI validation, view templates.
  - Write Ownership: Frontend directory tree (e.g., `src/client/`, `templates/`, `components/`).
- **Subagent 2 (Service / Logic / Persistence)**:
  - Scope: API endpoints, service business logic, data models, database queries.
  - Write Ownership: Backend directory tree (e.g., `src/server/`, `services/`, `models/`).
- **Subagent 3 (Verification / Harness / Test Suite)**:
  - Scope: Integration test cases, unit tests, fixtures, mock data, performance/security test scripts.
  - Write Ownership: Test directory tree (e.g., `tests/`, `specs/`).

#### Dispatch Contract Requirements:
For each subagent, the Main Agent must explicitly specify:
1. Exact subagent role and objective.
2. Disjoint write ownership (absolute or exact relative file paths).
3. Read-only reference paths (shared contracts, schema definitions, documentation).
4. Interface contracts (function signatures, JSON schemas, type definitions).
5. Reporting instructions (return code patches or write to designated output paths; never overwrite shared files).

---

### Phase 3: Parallel Execution & Concurrency Budget

- **Concurrency Limit**: Maximum 4 concurrent subagents at any time (typically 2 to 3).
- **Accounting**: If any background reviewer or secondary tool runs concurrently, it counts toward the 4-agent budget.
- **Monitoring**: The Main Agent monitors subagent progress, collecting deliverables as each task completes.
- **Strict Single-Writer Enforcement**: If two subagents attempt to modify the same file, the Main Agent terminates or re-routes one immediately.

---

### Phase 4: Central Integration & Conflict Resolution

Subagents never merge code into production branches or overwrite each other's work.
1. The Main Agent inspects all subagent outputs, diffs, and proposed modifications.
2. The Main Agent resolves interface differences or data model naming misalignments.
3. The Main Agent writes the integrated code directly into the workspace, preserving consistent style, import sorting, and documentation standards.

---

### Phase 5: Independent Technical Verification

The Main Agent independently executes programmatic verifications:
1. **Compilation / Build Check**:
   ```bash
   # Run project build command (e.g., npm run build, cargo build, etc.)
   ```
2. **Type Checking & Linting**:
   ```bash
   # Run linter and type checker (e.g., tsc --noEmit, flake8, eslint, etc.)
   ```
3. **Automated Test Suite**:
   ```bash
   # Run relevant unit and integration tests (e.g., pytest, npm test, etc.)
   ```
4. **Zero-Defect Verification**: Any failure must be investigated and resolved before advancing to Phase 6.

---

### Phase 6: Central EGM Final Loophole Review

Before delivering the completed work to the user, the Main Agent runs a final review to identify loopholes, unaddressed edge cases, or specification drift.

#### 1. EGM Availability Check:
Check whether the complete EGM plugin is installed and operational:
```bash
test -f ~/.gemini/config/plugins/egm/plugin.json && echo "EGM_AVAILABLE" || echo "EGM_UNAVAILABLE"
```

#### 2. EGM Review Execution (When Available):
- Invoke the EGM review workflow (or slash command `/egm:egm-review`) focusing on requirements completeness, design integrity, and implementation readiness.
- Reviewers evaluate the integrated changes against original goals and edge cases.
- Address any actionable findings identified by the review.

#### 3. Structured Native Fallback (When EGM is Unavailable):
- If the EGM plugin is not installed, output an explicit notice:
  `"EGM plugin unavailable. Activating structured native-subagent review fallback."`
- Spawn a dedicated fresh-context native subagent:
  - Role: `Loophole & Adversarial QA Auditor`
  - Scope: Read-only inspection of integrated files against user requirements, boundary conditions, error cases, and security vulnerabilities.
  - Output: Defect matrix with findings and actionable remediation recommendations.
- Address all Blocker and High severity findings.
- **Rule**: Never misrepresent same-context self-review as an independent Goldfish or EGM review.

---

### Phase 7: Delivery, Reporting & Release Gate

1. **Deliverables Summary**: Present a clear, structured summary to the user detailing:
   - Task sizing rationale and subagent decomposition structure.
   - Files created or modified with specific line/module summaries.
   - Technical verification results (build status, test pass counts).
   - EGM or native fallback review findings and resolution status.
2. **Product Owner Release Gate**:
   - Explicitly remind the user/team that milestone sign-off, production release, protected governance state transitions (such as Everly M0 sign-off or M1 unlocking), and issue closures require explicit, human Product Owner approval.
