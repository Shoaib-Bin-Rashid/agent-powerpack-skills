# Using Agent Powerpack Skills in Anthropic Claude Code

## Installation
Claude Code automatically discovers custom skills located in `~/.claude/skills/` or `.claude/skills/`.

Run:
```bash
./install.sh --claude
```

## Available Slash Commands / Prompts
1. `/teamform [task]`:
   Directs Claude Code to act as Lead Architect and Orchestrator, break down complex requirements into disjoint tasks, execute them with write isolation, integrate centrally, and run a loophole check before completing.

2. `/hard-review [path]`:
   Initiates a read-only adversarial review pipeline. Claude Code will inspect requirements, architecture, security, and edge-case concurrency, producing a structured finding matrix without mutating source code.
