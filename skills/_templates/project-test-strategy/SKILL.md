---
name: project-test-strategy
description: Testing philosophy and conventions for {{PROJECT_NAME}} — test types, naming, data fixtures, mocking rules, coverage targets, and the definition of done. Load when writing or reviewing tests. Replace this template with your project's real test strategy.
---

<!-- =====================================================================
AI AUTHORING INSTRUCTIONS  (delete this whole block once the skill is written)

You are generating the TEST-STRATEGY skill for {{PROJECT_NAME}} (slug: {{PROJECT_SLUG}}).
Your job: capture HOW the team tests, so the QA/dev agents write tests that fit in.

HOW TO POPULATE THIS FILE:
1. Scan for existing tests: file locations, naming patterns, frameworks
   (JUnit/Mockito/AssertJ, Jest, pytest, vitest…), fixture/builder patterns.
2. Scan CI config for the coverage gate and the exact test commands.
3. Infer the unit-vs-integration split from how existing tests are structured.
4. For things not in code — coverage TARGET, definition of done, what "must have a
   test" means for this team — ASK THE USER. One question at a time.

CONFIDENCE TAGGING: tag each non-trivial fact you write as [verified: <source-file-or-command>]
when you traced it to real code/config, or [inferred] / [open-question] when it needs the
user to confirm. This lets a reviewer instantly separate code-backed facts from assumptions.

DONE WHEN: the QA agent can derive a test matrix from acceptance criteria and write
tests that match existing style, and the reviewer can judge test quality, from this
file alone.
===================================================================== -->

# {{PROJECT_NAME}} — Test Strategy

## Testing Philosophy (1 paragraph)
<!-- What does "well tested" mean here? Test pyramid? TDD expected? -->
_TODO._

## Test Types & Where They Live
| Type | Location | Naming | Framework |
|------|----------|--------|-----------|
| Unit | _…_ | _…_ | _…_ |
| Integration | _…_ | _…_ | _…_ |
| (UI/e2e) | _…_ | _…_ | _…_ |

## Naming Convention
<!-- e.g. methodName_scenario_expectedResult ; describe/it phrasing -->
- _…_

## Test Data & Fixtures
<!-- Builders, factories, fixtures. "Never hardcode inline" type rules. -->
- _…_

## Mocking Rules
<!-- What to mock, what NOT to mock, how external systems are stubbed. -->
- _…_

## Assertion Standards
<!-- Specific assertions over assertNotNull; verify side effects; determinism. -->
- _…_

## Commands
| Purpose | Command |
|---------|---------|
| Run unit tests | `_…_` |
| Run integration tests | `_…_` |
| Run with coverage | `_…_` |

## Coverage Target & Definition of Done
<!-- The numeric gate + the checklist a change must satisfy to be "done". -->
- Coverage target: _…%_
- Definition of done:
  - [ ] _…_

## Not Testable Locally
<!-- Scenarios needing external systems; how the QA agent should report them. -->
- _…_
