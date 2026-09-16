---
name: project-domain
description: Business and domain knowledge for {{PROJECT_NAME}} — entities, lifecycles, status models, business rules, roles/permissions, and product vision. Load when reasoning about WHAT the software should do and WHY. Replace this template with your project's real domain knowledge.
---

<!-- =====================================================================
AI AUTHORING INSTRUCTIONS  (delete this whole block once the skill is written)

You are generating the DOMAIN skill for {{PROJECT_NAME}} (slug: {{PROJECT_SLUG}}).
Your job: capture the BUSINESS TRUTH of the system, not its code style.

HOW TO POPULATE THIS FILE:
1. Scan the codebase for the domain language:
   - Enums / status fields / state machines  → the lifecycles below
   - Entities / aggregates / DB tables         → the "Core Entities" section
   - Guard clauses / validation / exceptions   → the "Business Rules" section
   - Role / permission / security annotations  → the "Roles & Permissions" section
   - Integration clients / event names          → the "External Systems & Events" section
2. Read the ticket system (if configured) for product intent and vocabulary.
3. For anything the CODE CANNOT tell you (the "why", intended-but-unenforced rules,
   business meaning of enums, valid vs. invalid transitions), ASK THE USER —
   one focused question at a time. Do NOT guess on material domain decisions.
4. Prefer tables and explicit lists. A downstream agent must be able to answer
   "is transition A→C allowed?" from this file alone.

CONFIDENCE TAGGING: tag each non-trivial fact you write as [verified: <source-file-or-command>]
when you traced it to real code/config, or [inferred] / [open-question] when it needs the
user to confirm. This lets a reviewer instantly separate code-backed facts from assumptions.

DONE WHEN: another agent could implement or review a feature correctly using only
this file for domain truth, with no access to your reasoning.
===================================================================== -->

# {{PROJECT_NAME}} — Domain Knowledge

## Product Vision (1 paragraph)
<!-- What is this system for? Who uses it? What problem does it solve? -->
_TODO: describe the product in plain language._

## Glossary
<!-- Define every non-obvious domain term. Downstream agents rely on this. -->
| Term | Meaning |
|------|---------|
| _Term_ | _Definition_ |

## Core Entities
<!-- The nouns of the system and how they relate. -->
| Entity | Responsibility | Key relationships |
|--------|----------------|-------------------|
| _Entity_ | _What it represents_ | _Links to…_ |

## Lifecycles & Status Models
<!-- For each entity with a status, list ALL statuses and the VALID transitions.
     Mark which transitions are enforced in code vs. business-intended only. -->
### {{Entity}} lifecycle
- Statuses: _A, B, C…_
- Valid transitions:
  | From | To | Trigger | Enforced in code? |
  |------|----|---------|-------------------|
  | A | B | _action_ | yes/no |
- Invalid/forbidden transitions worth calling out: _…_

## Business Rules
<!-- The invariants. "X must never happen." "Y always cascades to Z." -->
- _Rule…_

## Roles & Permissions
<!-- Who can do what. Map to the auth model found in code. -->
| Role | Can | Cannot |
|------|-----|--------|
| _Role_ | _…_ | _…_ |

## External Systems & Events
<!-- Integrations, message/event contracts, what is mocked locally vs. not. -->
| System / Event | Purpose | Locally testable? |
|----------------|---------|-------------------|
| _…_ | _…_ | _yes/no_ |

## Known Anomalies / Gotchas
<!-- Legacy quirks, deprecated patterns, data edge cases future work must respect. -->
- _…_
