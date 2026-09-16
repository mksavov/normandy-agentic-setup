# Normandy Agentic Development Framework

A **plug-and-play, multi-agent pipeline** that takes a work item (a ticket or a pasted story) and
carries it through **recon → analysis → implementation → review → QA**, producing working code on
a branch plus a full paper trail — while you stay in the loop for the decisions that matter.

It ships configured for **[OpenCode](https://opencode.ai)**, but the agents are written as
portable prose so porting to Claude Code or Codex is a handful of mechanical edits (see
[Porting](#porting-to-other-tools)).

The framework knows *how to run a development pipeline*. It learns *your project* from a small set
of **project-knowledge skills** that you either write by hand or have the agents generate for you.

---

## The Crew

| Agent | Role | What it does | Default model |
|-------|------|--------------|---------------|
| **Captain** | Orchestrator | Runs the pipeline, routes between agents, escalates decisions to you | `claude-opus-4.8` |
| **Seer** | Analyst | Vets requirements & acceptance criteria against your domain rules | `claude-opus-4.8` |
| **Forger** | Developer | Implements the work following your conventions | `claude-sonnet-4.5` |
| **Sentinel** | Reviewer | Reviews the diff for bugs, conventions, security | `claude-sonnet-4.5` |
| **Probe** | QA | Derives tests from the ACs, writes and runs them | `claude-haiku-4.5` |
| **Scout** | Recon | Cheaply maps the codebase area a story touches | `claude-haiku-4.5` |

Models are just defaults. Change them in each agent's frontmatter (`model:` field). The IDs shown
use the `github-copilot/` provider prefix — adjust to your provider.

---

## How It Works

```
        ┌─────────┐
        │ Captain │  orchestrates everything, talks to you
        └────┬────┘
   Phase 0   │  Scout    → context.md     (map the area)
   Phase 1   │  Captain  → story.md       (record the story, cut branches)
   Phase 2   │  Seer     → analysis.md    (vet the requirements)
   Phase 3   │  Forger   → implementation-log.md
   Phase 4   │  Sentinel → review-N.md    (≤ 2 review cycles)
   Phase 5   │  Probe    → qa-report.md   (≤ 2 QA cycles)
   Phase 6   │  Captain  → summary.md     (hand back to you)
```

Every phase writes a **traceability artifact** into `<ARTIFACT_DIR>/<TICKET>/`. Every artifact
starts with a machine-readable `STATUS:` line the Captain uses to route deterministically. Agents
share findings through a living `context.md` so nobody re-derives what another already learned.

**The Captain never commits or pushes.** It creates branches and writes code; you review and ship.

---

## Project Knowledge — the one thing you provide

The agents are generic. Your project's truth lives in **four canonical skills**:

| Skill | Answers | Authored by (bootstrap) |
|-------|---------|--------------------------|
| `project-domain` | What the system does & why; entities, lifecycles, rules, roles | Seer |
| `project-architecture` | How code is structured & written; build/codegen commands | Forger |
| `project-test-strategy` | How you test; coverage target; definition of done | Probe |
| `project-workflow` | Ticket source, branch strategy, PR/CI gates | Captain |

**You can add as many extra skills as you like.** Any skill whose name/description references your
**project slug** (e.g. `acme-billing-rules`, `acme-legacy-quirks`) is auto-discovered and loaded by
every agent — no agent edits required. Use this to split a large domain into focused pieces.

You don't have to write these by hand — see [Bootstrap](#4-generate-your-project-knowledge).

---

## Setup — Step by Step

### Prerequisites
- OpenCode installed, with a model provider configured.
- A POSIX shell (macOS/Linux). `setup.sh` is plain bash — no Node, no npm, no build.
- *(Optional)* the `gh` CLI if you want GitHub-issue tickets; a Jira MCP if you want Jira.

### The whole flow

Say your project is `~/myproject` and you want to add the crew to it.

### 1. Clone the framework

Clone it somewhere **outside** your project — it's a reusable source you can point at many projects.

```bash
git clone <your-fork-url> ~/agentic-dev-framework
cd ~/agentic-dev-framework
```

### 2. Run setup

```bash
./setup.sh
```

`setup.sh` asks a handful of questions (each with a sensible default — press Enter to accept):

| Prompt | Meaning | Example |
|--------|---------|---------|
| Project name | Human-readable | `Acme Billing` |
| Project slug | Keyword for extra-skill discovery | `acme` |
| Workspace root | Absolute path where your repos live | `/Users/you/myproject` |
| Ticket prefix | Ticket key prefix | `ACME` |
| Default base branch | Branch to cut work from | `develop` |
| Ticket source | `manual` \| `github` \| `jira` | `manual` |
| Artifact directory | Where the paper trail is written | `.agentic/stories` |
| **Target project** | The project to install the crew into | `/Users/you/myproject` |

It then **copies the crew into `<target-project>/.opencode/`** — agents, commands, and the four
skill templates — with every `{{PLACEHOLDER}}` already substituted. The framework repo itself stays
pristine (placeholders intact), so you can reuse it for other projects later.

> **Why copy into the project?** OpenCode discovers agents/commands/skills from the `.opencode/`
> directory of the project you open it in. Installing them there is the simplest, most reliable
> path — and matches how OpenCode project setups normally work. (If you'd rather have the crew in
> *every* project, copy the installed `.opencode/agents`, `.opencode/commands`, and skills into your
> global `~/.config/opencode/` — `agent/` and `command/` singular — instead.)

### 3. Open OpenCode from your project

Run OpenCode from the project directory so it discovers the newly installed crew.

```bash
cd ~/myproject
opencode
```

### 4. Generate your project knowledge

Inside OpenCode, from your project:

**Option A — let the agents do it (recommended):**
```
/bootstrap-project
```
Scout maps your codebase; Seer, Forger, Probe, and the Captain each fill in their skill from the
template — **scanning your code and ticket system, and asking you focused questions only about what
the code can't reveal** (business intent, coverage targets, review process). You end up reviewing
AI-drafted skills instead of writing them from scratch.

**Option B — by hand:** open the four installed `SKILL.md` files under
`~/myproject/.opencode/skills/` and follow the authoring guidance embedded at the top of each.

### 5. Develop something
```
/develop ACME-1234
```
or paste a story:
```
/develop As a user I want ... Acceptance criteria: 1) ... 2) ...
```
The Captain runs the full pipeline and hands you a summary with the branch(es) and next steps.

You can also run analysis only:
```
/analyze <ticket-or-story>
```

> **Re-running setup / updating the crew:** just run `./setup.sh` again from the framework repo and
> point it at the same project. Existing skills are never overwritten; agents/commands are
> refreshed from the latest framework version.

---

## Ticket Sources

| Source | Setup needed | How a ticket is fetched |
|--------|--------------|-------------------------|
| **manual** *(default)* | none | You paste the story text, or point at a local file. |
| **github** | `gh` CLI authenticated | `gh issue view <n>` — a bare number means that issue. |
| **jira** | a Jira MCP configured in OpenCode | via `jira_*` tools — a bare number means `<PREFIX>-<n>`. |

`manual` needs **zero** external configuration, so the framework runs out of the box. The Captain
**never writes back** to any tracker unless you explicitly ask.

---

## What Gets Produced

For each work item, under `<ARTIFACT_DIR>/<TICKET>/`:

```
context.md              shared handoff notes (Scout seeds, everyone appends)
story.md                the original story + acceptance criteria
analysis.md             Seer's requirement/domain analysis
implementation-log.md   Forger's task breakdown + notes
review-1.md [review-2]  Sentinel's review(s)
qa-report.md            Probe's test matrix + results
summary.md              Captain's final report + next steps
```

---

## Porting to Other Tools

The framework is OpenCode-first. The **agent bodies are tool-neutral prose**; only the thin wrapper
differs per tool. To port:

1. **Frontmatter** — translate each agent's YAML (`mode`, `model`, `permission`) to the target
   tool's schema (e.g. Claude Code's agent frontmatter, or Codex's config). Keep the Markdown body.
2. **Model IDs** — drop the `github-copilot/` prefix or swap to the target provider's IDs.
3. **Subagent dispatch** — OpenCode uses a `task`/`@mention` mechanism. Claude Code uses its `Task`
   tool; map the crew names to whatever subagent mechanism the tool provides.
   > **Codex note:** Codex has no native subagent orchestration. Either run the Captain's phases
   > sequentially yourself, or collapse the crew into a single agent that plays each role in turn.
4. **Skill loading** — if the target tool lacks a skill system, paste the project-knowledge skills
   into the agent's context or an `AGENTS.md`/system prompt instead.
5. **Commands** — recreate `/develop`, `/analyze`, `/bootstrap-project` as the target tool's
   command/prompt equivalent.

Nothing about the pipeline logic, roles, or project-knowledge model changes — only the wiring.

---

## Customizing

- **Change models:** edit each agent's `model:` field.
- **Change permissions:** each agent's `permission:` block scopes what it can edit/run. The
  Captain is deliberately blocked from `git commit/push/merge/rebase`.
- **Add project knowledge:** drop more `<slug>-*.md` skills into your skills dir — auto-discovered.
- **Change cycle caps / phases:** edit `captain.md` (review and QA default to a 2-cycle cap).

---

## License

TBD
