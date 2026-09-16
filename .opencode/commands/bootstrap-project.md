---
description: Auto-generate the four canonical project-knowledge skills by scanning the codebase and ticket system
agent: captain
---

Bootstrap the project-knowledge skills for **{{PROJECT_NAME}}** (slug `{{PROJECT_SLUG}}`,
workspace `{{WORKSPACE_ROOT}}`).

## Where the skills live (IMPORTANT)

You are running **from the target project**, not the framework repo. The four skill templates were
already installed here by `setup.sh` and currently sit in **template state** at:

```
{{WORKSPACE_ROOT}}/.opencode/skills/project-domain/SKILL.md
{{WORKSPACE_ROOT}}/.opencode/skills/project-architecture/SKILL.md
{{WORKSPACE_ROOT}}/.opencode/skills/project-test-strategy/SKILL.md
{{WORKSPACE_ROOT}}/.opencode/skills/project-workflow/SKILL.md
```

> If they are not there, look under `.opencode/skills/` relative to the project root, then under
> any configured OpenCode skills directory. Do **not** look in the framework repo's
> `skills/_templates/` — that path does not exist in this project. If you truly cannot find them,
> ask the user for the skills directory.

**Goal:** rewrite each of those four files **in place** — replacing the template body with real,
verified project knowledge, and removing the `<!-- AI AUTHORING INSTRUCTIONS -->` block — keeping
the canonical names and frontmatter.

## Orchestration

1. **Seed context, then recon.** Create `{{ARTIFACT_DIR}}/bootstrap/context.md` yourself with a
   one-line project summary and workspace root. Then dispatch **@scout** to append a structural map
   (modules, tech stacks, build files, test locations, entry points, ticket vocabulary). If Scout
   returns `STATUS: BLOCKED`, persist its returned notes into `context.md` yourself.

2. **Author each skill.** Each agent must **write its own skill file in place** at the path above,
   following the template's embedded authoring instructions, and asking the user focused questions
   **only** about what the code cannot reveal (one question at a time):
   - `project-domain` → **@seer**
   - `project-architecture` → **@forger**
   - `project-test-strategy` → **@probe**
   - `project-workflow` → **you (Captain)** (seed from the setup config values)

3. **Write contract (enforced).** Every authoring agent MUST write its file and verify it by
   reading it back, then return only a `STATUS:` line + the path + a one-line summary. If an agent
   returns `STATUS: BLOCKED` (could not write) with fenced content, **persist that content
   yourself** to the correct path. If an agent returns a prose summary instead of writing the file,
   treat it as failed: re-dispatch once demanding it write the file (or return full fenced
   content), and persist it yourself if needed. **Never accept a prose summary as the artifact.**

4. **Tag confidence.** In every generated skill, mark each non-trivial fact as either
   `[verified: <source>]` (traced to a file/command you actually read) or `[inferred]` /
   `[open-question]` (needs user confirmation). This lets a reviewer instantly see what is
   code-backed vs. assumed.

5. **Finish.** Confirm all four files have: no `AI AUTHORING` block, no leftover template
   placeholders (`_…_`, `TODO`, `{{ }}`), and intact frontmatter (read each back to verify).
   Then summarize what was generated and list every **Open Question** the user still needs to
   answer, ordered by how much it de-risks future work.

$ARGUMENTS
