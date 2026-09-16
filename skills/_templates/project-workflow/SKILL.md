---
name: project-workflow
description: Delivery-process knowledge for {{PROJECT_NAME}} — ticketing system, branch strategy, repo paths, commit and PR conventions, and CI gates. Load when orchestrating a story from ticket to ready-for-PR. Replace this template with your project's real workflow.
---

<!-- =====================================================================
AI AUTHORING INSTRUCTIONS  (delete this whole block once the skill is written)

You are generating the WORKFLOW skill for {{PROJECT_NAME}} (slug: {{PROJECT_SLUG}}).
Your job: capture the DELIVERY PROCESS so the orchestrator can go from a ticket to a
ready-for-review branch correctly.

HOW TO POPULATE THIS FILE:
1. Confirm/expand the values set at setup: ticket source & prefix, workspace root,
   default base branch, artifact dir.
2. Scan for CONTRIBUTING.md, CI config (.github/workflows, Jenkinsfile, .gitlab-ci),
   branch-naming hints in git history, PR templates.
3. For process not written down anywhere — review requirements, who approves, release
   branching — ASK THE USER. One question at a time.

CONFIDENCE TAGGING: tag each non-trivial fact you write as [verified: <source-file-or-command>]
when you traced it to real code/config, or [inferred] / [open-question] when it needs the
user to confirm. This lets a reviewer instantly separate code-backed facts from assumptions.

DONE WHEN: the orchestrator can resolve a ticket, name and cut a branch correctly, and
tell the user exactly what CI/PR steps remain.
===================================================================== -->

# {{PROJECT_NAME}} — Delivery Workflow

## Configured Values (from setup)
| Setting | Value |
|---------|-------|
| Project slug | `{{PROJECT_SLUG}}` |
| Workspace root | `{{WORKSPACE_ROOT}}` |
| Ticket source | `{{TICKET_SOURCE}}` |
| Ticket prefix | `{{TICKET_PREFIX}}` |
| Default base branch | `{{DEFAULT_BASE_BRANCH}}` |
| Artifact directory | `{{ARTIFACT_DIR}}` |

## Ticket Source Details
<!-- How to fetch a story. Fill the section matching {{TICKET_SOURCE}}. -->
- **manual**: story text is pasted by the user or lives in a local file.
- **github**: fetch via `gh issue view <n> --json title,body`. Repo: _…_
- **jira**: fetch via the configured Jira MCP. Project key: `{{TICKET_PREFIX}}`.

## Branch Strategy
<!-- Names + base branches per work type. -->
| Work type | Branch pattern | Base branch |
|-----------|----------------|-------------|
| Feature | `feature/{{TICKET_PREFIX}}-<n>-<slug>` | `{{DEFAULT_BASE_BRANCH}}` |
| Bugfix | `bugfix/{{TICKET_PREFIX}}-<n>-<slug>` | _release branch or default_ |
| Hotfix | `hotfix/{{TICKET_PREFIX}}-<n>-<slug>` | _main/production_ |

## Commit Convention
<!-- e.g. Conventional Commits. -->
- _…_

## PR & CI Gates
<!-- What must be green/approved before merge. -->
- Required reviewers: _…_
- CI checks that must pass: _…_
- Merge target: `{{DEFAULT_BASE_BRANCH}}`
