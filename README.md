<div align="center">

# ⚡ Agent Powerpack Skills

**Universal Multi-Agent Orchestration & Adversarial Review Toolkit for AI Coding Agents**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Antigravity](https://img.shields.io/badge/Google-Antigravity_CLI-4285F4.svg)](https://antigravity.google)
[![Claude Code](https://img.shields.io/badge/Anthropic-Claude_Code-D97706.svg)](https://claude.ai)
[![Cursor](https://img.shields.io/badge/Cursor-Windsurf-000000.svg)](https://cursor.com)
[![OpenCode](https://img.shields.io/badge/OpenCode-Codex-10A37F.svg)](https://github.com)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)

*Battle-tested skills that give your AI coding agents enterprise-grade multi-agent teamwork, parallel swarm orchestration, and deep adversarial quality gates.*

</div>

---

## 🚀 Overview

Modern AI coding agents (Antigravity CLI, Claude Code, Cursor, OpenCode) are powerful individually, but they stumble when handling complex, full-stack tasks or catching subtle architectural regressions.

**Agent Powerpack Skills** provides two flagship, production-grade skills that transform single-threaded agents into a cohesive engineering workforce:

1. **`/teamform` — Parallel Swarm Orchestrator**:
   Analyzes task complexity, spawns 2-3 specialized subagents with strict write isolation (e.g. Frontend/UI, Backend/DB, Tests/Research), integrates changes centrally, and conducts an EGM final loophole check before delivery.

2. **`/hard-review` — Deep Adversarial Review Engine**:
   A strictly read-only audit engine combining a 5-stage EGM review protocol, fresh-context specialized review personas (Security & RLS, Concurrency & QA, 100% Traceability), read-only Git baseline comparison, and structured finding matrices.

---

## 🏗️ Architecture & Execution Flows

### 1. `/teamform` Execution Flow

```mermaid
flowchart TD
    subgraph S1["Main Agent / Orchestrator"]
        ORCH["Task Analysis & Complexity Evaluation"]
    end

    subgraph S2["Parallel Specialized Subagent Swarm (Write-Isolated)"]
        A1["Agent 1: Frontend / UI"]
        A2["Agent 2: Backend / Database"]
        A3["Agent 3: Research / Tests"]
    end

    subgraph S3["Central Integration & Verification"]
        INT["Collect -> Resolve Conflicts -> Integrate Code -> Run Tests"]
    end

    subgraph S4["Adversarial Quality Gate"]
        EGM["EGM Final Loophole Review<br/>(Check loopholes, missed requirements, edge cases)"]
    end

    DELIV(["Final Verified Delivery"])

    ORCH --> A1
    ORCH --> A2
    ORCH --> A3
    A1 --> INT
    A2 --> INT
    A3 --> INT
    INT --> EGM
    EGM --> DELIV

    classDef primary fill:#2563eb,stroke:#1d4ed8,color:#ffffff,stroke-width:2px;
    classDef worker fill:#3b82f6,stroke:#1d4ed8,color:#ffffff;
    classDef gate fill:#7c3aed,stroke:#6d28d9,color:#ffffff;
    classDef success fill:#059669,stroke:#047857,color:#ffffff;

    class ORCH primary;
    class A1,A2,A3 worker;
    class INT,EGM gate;
    class DELIV success;
```

---

### 2. `/hard-review` Adversarial Audit Pipeline

```mermaid
flowchart TD
    INPUT["Target Artifacts<br/>(Specs, Architecture, Code Diffs)"] --> BASELINE["Capture Initial Git Status & Diff Baseline"]

    BASELINE --> AUDIT_SWARM

    subgraph AUDIT_SWARM["Multi-Tiered Adversarial Review Swarm"]
        direction TB
        subgraph EGM_5STAGE["EGM 5-Stage Protocol (Specs / Plans)"]
            E1["Stage 5: Strategic Review (zoom_out)"]
            E2["Stage 6: Comprehension Test (comprehension)"]
            E3["Stage 7: Critic Review (design_critic + structural + style)"]
            E4["Stage 8: Intermediate Zoom Out (zoom_out)"]
            E5["Stage 9: Readiness (implementation_readiness + codebase_details)"]
            E1 --> E2 --> E3 --> E4 --> E5
        end

        subgraph SPECIALIZED["Fresh-Context Domain Auditors"]
            S1["Security & Authorization Auditor<br/>(RLS, DB roles, rolsuper, rolbypassrls, IDOR)"]
            S2["QA & Concurrency Hunter<br/>(Race conditions, SELECT FOR UPDATE, timezone edge cases)"]
            S3["Completeness & Traceability Verifier<br/>(100% Bidirectional mapping, explicit N/A rationale)"]
        end

        subgraph PROGRAMMATIC["Programmatic Verification"]
            P1["Git Baseline Diff Validation (Zero Accidental Writes)"]
            P2["Scripted AST & Metric Reconciliation"]
            P3["Automated Unicode & Character Scanner"]
        end
    end

    AUDIT_SWARM --> REPORT["Standardized Finding Matrix<br/>(Blocker, High, Medium, Low, Advisory)"]
    REPORT --> GATE{"Product Owner<br/>Release Gate"}
    GATE -->|Approved by Human PO| SHIP(["Verified Release"])
    GATE -->|Remediation Needed| LOOP["Max 2-3 Authorized Re-audit Cycles"]

    classDef input fill:#374151,stroke:#1f2937,color:#ffffff;
    classDef egm fill:#4f46e5,stroke:#4338ca,color:#ffffff;
    classDef spec fill:#0284c7,stroke:#0369a1,color:#ffffff;
    classDef prog fill:#0d9488,stroke:#0f766e,color:#ffffff;
    classDef gate fill:#dc2626,stroke:#b91c1c,color:#ffffff;
    classDef success fill:#059669,stroke:#047857,color:#ffffff;

    class INPUT,BASELINE input;
    class E1,E2,E3,E4,E5 egm;
    class S1,S2,S3 spec;
    class P1,P2,P3 prog;
    class GATE gate;
    class SHIP success;
```

---

## 📦 Compatibility Matrix

| AI Coding Agent | Configuration Path | Skill Discovery | Status |
|---|---|---|---|
| **Google Antigravity CLI** | `~/.gemini/skills/` | Native CLI auto-discovery | Supported |
| **Anthropic Claude Code** | `~/.claude/skills/` | Automatic slash command | Supported |
| **Cursor / Windsurf** | `.cursor/rules/`, `.cursorrules` | Workspace rules integration | Supported |
| **OpenCode CLI** | `~/.opencode/skills/` | Native skill registry | Supported |
| **OpenAI Codex / CLI** | Custom prompt wrappers | Command adapter | Supported |

---

## ⚡ Installation

### 1-Line Universal Installer (Recommended)
Automatically detects your installed agent environments and links the skills:

```bash
curl -fsSL https://raw.githubusercontent.com/shoaib/agent-powerpack-skills/main/install.sh | bash
```

### Manual Installation
Clone the repository and run the installer for your target agent:

```bash
git clone https://github.com/shoaib/agent-powerpack-skills.git
cd agent-powerpack-skills

# Install to Google Antigravity
./install.sh --antigravity

# Install to Claude Code
./install.sh --claude

# Install to Cursor / Windsurf
./install.sh --cursor

# Install to all supported environments
./install.sh --all
```

---

## 🛡️ Core Invariants & Governance

1. **Write-Isolation Invariant**:
   Parallel subagents are strictly partitioned into disjoint write boundaries. Concurrent edits to the same file or schema are forbidden. All merging and schema modifications are performed centrally.

2. **Concurrency Budget Limit**:
   Caps execution at 4 concurrent subagents maximum (normally 2-3), preventing host memory exhaustion on 8 GB / 16 GB developer machines.

3. **Read-Only Hard-Review Invariant**:
   `/hard-review` never mutates reviewed source artifacts or executes unauthorized auto-fixes. Findings are compiled into designated report directories with diff-based remediations.

4. **Product Owner Release Gate**:
   Strict rule prohibiting production release, milestone sign-off, or issue closure without explicit human Product Owner approval.

---

## 📄 License

Distributed under the [MIT License](LICENSE). Free for personal, commercial, and enterprise use.

---

<div align="center">
  <b>Built with precision for the next generation of autonomous engineering agents.</b><br/>
  Star ⭐ this repo if you find it valuable!
</div>
