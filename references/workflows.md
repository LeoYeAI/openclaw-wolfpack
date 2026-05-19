# Workflows Reference

Wolfpack ships with 4 pre-built collaborative workflows.

## 1. Paper Pipeline (Full Research → Submission)

**Duration:** ~12 weeks | **Phases:** 9 (including quality gates)

```
Phase 0: Init (Planner) → Define target venue, DDL, scope
Phase 1: Survey (Surveyor, 1-2w) → Literature review, gap identification  
Phase 2: Ideation (Ideator, 1w) → Generate 3-5 candidates, ACE scoring
Phase 2.5: 🎯 TASTE GATE (Critic) → SHARP ≥ 18 required to proceed
Phase 3: Design (Ideator+Coder, 1-2w) → Method design, Parsimony check
Phase 4: Implementation (Coder, 2-4w) → Code + sanity checks
Phase 5: Experiments (Coder, 2-3w) → Main + ablation + analysis
Phase 6: Writing (Writer, 2-3w) → Full paper + narrative check
Phase 7: Review (Reviewer+Critic, 1-2w) → Internal review + quality gate
Phase 8: Submit (Planner) → Camera-ready + final audit
```

**Key Rule:** No phase can start until the previous gate passes. SHARP < 18 → return to Ideator.

## 2. Brainstorm (Rapid Idea Generation)

**Duration:** 1-2 hours | **Trigger:** `/brainstorm` or manual request

```
Step 1: Context prep (Planner+Scout, 5min) → Constraints + latest trends
Step 2: Free diverge (Ideator) → Generate 5-10 rough ideas from 4 dimensions
Step 3: Novelty check (Surveyor) → Quick dedup against literature
Step 4: ACE scoring (Ideator+Planner) → Rank candidates
Step 5: Deep dive Top 2 (with user) → Detailed discussion
Step 5.5: 🎯 SHARP gate (Critic) → Must pass before formalization
Step 6: Idea Card output → Deliver to Planner for pipeline entry
```

## 3. Rebuttal (Response to Reviewer Comments)

**Duration:** 5-7 days | **Trigger:** Reviewer comments received

```
Step 1: Analysis (Reviewer) → Classify each comment (🔴 valid / 🟡 misunderstanding / 🟢 suggestion / ⚪ out-of-scope)
Step 2: Strategy (Planner+Reviewer) → Prioritize, assign tasks
Step 3: Parallel work → Coder: supplementary experiments | Writer: revision drafts | Surveyor: missing citations
Step 4: Draft rebuttal (Writer) → Structured response per reviewer
Step 5: Internal QA (Reviewer) → Verify completeness, tone, evidence
Step 6: Submit
```

## 4. Daily Digest (Automated Monitoring)

**Frequency:** Daily (configurable) | **Lead:** Scout

```
Step 1: Collect → arXiv (cs.CL/AI/LG/MA), Semantic Scholar, lab blogs
Step 2: Filter → Keyword + author + relevance scoring
Step 3: Summarize → Top 3-5 papers with one-line summary + relevance rating
Step 4: Alert check → 🔴 collision warning | 🟡 breakthrough | 🟡 DDL reminder
Step 5: Distribute → Report to user, alerts to Planner, leads to Ideator
```

Weekly bonus: trend summary + competitive landscape update.

## Communication Topology

```
         ┌──────────┐
         │  Planner │ ← Central hub, coordinates all
         └────┬─────┘
              │
    ┌─────┬──┴──┬─────┬──────┐
    ▼     ▼     ▼     ▼      ▼
 Ideator Scout Coder Writer Surveyor
    ↕              ↕
 Critic         Reviewer
```

- **Planner ↔ All**: Bidirectional task dispatch and status reports
- **Ideator ↔ Critic**: Adversarial idea refinement (creative tension)
- **Writer ↔ Reviewer**: Iterative paper improvement
- **Scout → Ideator**: Inspiration feed
- **Surveyor → Ideator**: Novelty verification
