---
description: Auto-generate the four canonical project-knowledge skills by scanning the codebase and ticket system
agent: captain
---

Bootstrap the project-knowledge skills for **{{PROJECT_NAME}}** (slug `{{PROJECT_SLUG}}`,
workspace `{{WORKSPACE_ROOT}}`).

Goal: turn the four template skills under `skills/_templates/` into real, filled-in skills for
this project, saved where OpenCode discovers skills (see README — typically the project's
`skills/` or `.opencode/skills/` directory), named canonically: `project-domain`,
`project-architecture`, `project-test-strategy`, `project-workflow`.

Orchestrate it like this:

1. **Recon (@scout):** produce a structural map of `{{WORKSPACE_ROOT}}` — modules, tech stacks,
   build files, test locations, entry points, ticket-system vocabulary. Write it to a scratch
   `context.md` the other agents can read.

2. **Author in parallel where possible, each following its template's embedded AI-authoring
   instructions and asking the user focused questions ONLY about what the code cannot reveal
   (one question at a time):**
   - `project-domain` → **@seer** (business rules, lifecycles, product intent)
   - `project-architecture` → **@forger** (layout, conventions, exact build/codegen commands)
   - `project-test-strategy` → **@probe** (test patterns, coverage target, definition of done)
   - `project-workflow` → **you (Captain)** (ticket source, branch strategy, PR/CI gates —
     seeded from the setup config values)

3. Each finished skill must have its `<!-- AI AUTHORING INSTRUCTIONS -->` block removed and be
   ready to load by name.

4. Summarize what was generated and list every open question the user still needs to answer.

$ARGUMENTS
