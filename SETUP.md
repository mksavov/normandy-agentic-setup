# Setup Reference

This file documents the configuration model in depth. For the quick start, see the
[README](./README.md).

## Configuration values

`setup.sh` collects these once and substitutes them across the agent and command files. They are
persisted to `.agentic/local.config` so re-runs offer them as defaults.

| Placeholder | Meaning | Default |
|-------------|---------|---------|
| `{{PROJECT_NAME}}` | Human-readable project name | `My Project` |
| `{{PROJECT_SLUG}}` | Lowercase keyword used to auto-discover extra project skills | `myproject` |
| `{{WORKSPACE_ROOT}}` | Absolute path where your repos live | `$HOME/<slug>` |
| `{{TICKET_PREFIX}}` | Ticket key prefix | `TASK` |
| `{{DEFAULT_BASE_BRANCH}}` | Branch new work is cut from | `develop` |
| `{{TICKET_SOURCE}}` | `manual` \| `github` \| `jira` | `manual` |
| `{{ARTIFACT_DIR}}` | Where traceability artifacts are written | `.agentic/stories` |
| `SKILLS_DIR` | Where the four project skills are installed (not a placeholder — used by the installer only) | `<workspace>/.opencode/skills` |

## What `setup.sh` does

1. Loads previous answers from `.agentic/local.config` (if present) as defaults.
2. Prompts for each value.
3. Confirms, then persists answers.
4. Replaces every `{{PLACEHOLDER}}` in `.opencode/agents/*.md` and `.opencode/commands/*.md`.
5. Copies the four templates from `skills/_templates/` into `SKILLS_DIR`, substituting placeholders
   in the copies. Existing skills are **not** overwritten.

It is pure `bash` + `sed`, compatible with macOS's bash 3.2. No Node, npm, or build step.

## What `setup.sh` does NOT do

- It does **not** write your project knowledge — run `/bootstrap-project` or edit the skills.
- It does **not** install or configure OpenCode, model providers, or MCP servers.
- It does **not** configure Jira. If `TICKET_SOURCE=jira`, add a Jira MCP to your OpenCode config
  yourself. `manual` and `github` need no MCP.

## The skill slots

| Canonical name | Loaded by | Purpose |
|----------------|-----------|---------|
| `project-domain` | Captain, Seer, Forger, Sentinel, Probe | Business/domain truth |
| `project-architecture` | Captain, Forger, Sentinel, Probe | Structure & conventions |
| `project-test-strategy` | Forger, Sentinel, Probe | Testing rules & DoD |
| `project-workflow` | Captain | Delivery process |

Extra skills named `<slug>-*` (matching `{{PROJECT_SLUG}}`) are auto-loaded by every agent.

## Re-running

Safe to re-run `setup.sh` at any time. Placeholders already substituted won't match again, so only
new/unfilled ones change. To start clean, re-clone or `git checkout` the agent files first.
