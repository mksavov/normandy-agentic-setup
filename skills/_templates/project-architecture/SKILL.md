---
name: project-architecture
description: Structural and code-convention knowledge for {{PROJECT_NAME}} — repo layout, tech stack, package/file conventions, build and code-generation pipeline, and shared coding standards. Load when reasoning about HOW code is structured and written. Replace this template with your project's real architecture knowledge.
---

<!-- =====================================================================
AI AUTHORING INSTRUCTIONS  (delete this whole block once the skill is written)

You are generating the ARCHITECTURE skill for {{PROJECT_NAME}} (slug: {{PROJECT_SLUG}}).
Your job: capture HOW code is organized and written, so a developer/reviewer agent
produces code indistinguishable from the team's.

HOW TO POPULATE THIS FILE:
1. Scan {{WORKSPACE_ROOT}} for:
   - Repo/module layout, build files (pom.xml, package.json, build.gradle, etc.)
   - Framework markers (Spring, Angular, React, Django…) and their versions
   - Directory conventions (where do controllers/services/components live?)
   - Naming conventions (suffixes, casing) — infer from existing files
   - Code-generation steps (OpenAPI codegen, protobuf, ORM migrations)
   - Lint/format config (eslint, prettier, spotless, checkstyle) → the exact commands
2. Where the codebase is INCONSISTENT (e.g. two injection styles, two folder
   patterns), ASK THE USER which is the standard — one question at a time.
3. Record EXACT build/test/lint/codegen COMMANDS. Downstream agents run these verbatim.

DONE WHEN: a developer agent could add a new endpoint/component and a reviewer agent
could flag convention violations using only this file.
===================================================================== -->

# {{PROJECT_NAME}} — Architecture & Conventions

## Tech Stack
<!-- Languages, frameworks, major libraries, versions. -->
| Layer | Technology | Version |
|-------|-----------|---------|
| _…_ | _…_ | _…_ |

## Repository / Module Layout
<!-- Every repo or module under {{WORKSPACE_ROOT}} and its responsibility.
     Note ordering dependencies (e.g. "spec repo must build before backend"). -->
| Repo / Module | Path | Responsibility |
|---------------|------|----------------|
| _…_ | `{{WORKSPACE_ROOT}}/…` | _…_ |

## Package / Directory Conventions
<!-- The internal structure inside a module. Where does each kind of file go? -->
- _e.g. controllers in `controller/`, services split into `contract/` + `impl/`…_

## Naming Conventions
| Kind | Rule | Example |
|------|------|---------|
| _Files_ | _…_ | _…_ |
| _Classes/Types_ | _…_ | _…_ |

## Build, Test, Lint & Codegen Commands
<!-- EXACT commands. Agents run these. -->
| Purpose | Command | Run where |
|---------|---------|-----------|
| Build | `_…_` | _module_ |
| Codegen | `_…_` | _module_ |
| Lint/format | `_…_` | _module_ |
| Test | `_…_` | _module_ |

## Mandatory Coding Standards
<!-- The rules a reviewer will enforce. Be specific and cite where they apply. -->
- _…_

## Persistence & Migrations
<!-- ORM, migration tool, how new migrations are added (never edit history!). -->
- _…_

## API / Contract Workflow
<!-- If API-first: the spec-first, codegen-driven flow. If not, delete. -->
- _…_

## Messaging / Async (if any)
<!-- Event bus, outbox pattern, scheduling guards. -->
- _…_

## Anti-Patterns To Reject
<!-- Concrete "never do X" rules for the reviewer. -->
- _…_
