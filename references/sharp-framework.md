# SHARP Evaluation Framework

The Critic agent uses SHARP to evaluate research ideas at quality gates.

## Dimensions (each scored 1-5)

### S — Sharpness (锐度)
Can you explain WHY the method works in one sentence?

- 5: Crystal clear, one-sentence insight that makes people say "of course"
- 4: Clear core insight, minor ambiguity
- 3: Decent idea but explanation needs work
- 2: Vague insight buried under complexity
- 1: Cannot articulate why it works

**Tests:**
- "One-sentence insight test": If you can't say it in one sentence, it's not sharp enough
- "Bar test": Could you make a peer say "that's interesting" in 30 seconds?

### H — Horizon (视野)
Will this problem still matter in 3-5 years?

- 5: Opens a new research direction, cited across fields
- 4: Solid long-term value within the field
- 3: Relevant now but may not age well
- 2: Trend-chasing, narrow window
- 1: Already obsolete or trivial

### A — Asymmetry (信息不对称)
Do you have a unique angle that others lack?

- 5: Novel data/perspective no one else has
- 4: Unique combination of existing ideas
- 3: Fresh take on known problem
- 2: Obvious next step anyone could take
- 1: Pure replication with cosmetic changes

### R — Resistance (抗审稿性)
Can the toughest reviewer break your core argument?

- 5: Rock solid — every objection has a strong counter
- 4: Mostly defensible, minor gaps
- 3: Survivable but needs careful framing
- 2: Major vulnerability that's hard to patch
- 1: Fundamental flaw in reasoning

**Test:** Simulate top 3 toughest reviewer questions and prepare answers.

### P — Parsimony (简约性)
Is the method elegantly simple?

- 5: Beautifully minimal — "why didn't I think of that?"
- 4: Clean design with justified complexity
- 3: Reasonable but could be simpler
- 2: Overly complex for marginal gains
- 1: Kitchen sink approach, no core insight

## Scoring Tiers

| Score | Tier | Verdict |
|-------|------|---------|
| 23-25 | 🏆 Exquisite | Rare taste — full speed ahead |
| 18-22 | 🟢 Refined | Reliable quality — worth investing |
| 13-17 | 🟡 Raw | Has potential — needs significant polish |
| ≤12 | 🔴 Bland | Lacks soul — start over |

**Hard rule:** Ideas scoring < 18 cannot proceed past Phase 2.5 (max 3 iteration rounds with Ideator before escalation).

## Anti-Pattern Detection

The Critic also checks for these common mediocrity patterns:

| Pattern | Symptom | Critic's Challenge |
|---------|---------|-------------------|
| Shell Innovation | Rebranding existing method | "Remove your brand name — what's the real difference from X?" |
| Kitchen Sink | Piling unrelated modules | "Which component is your insight? Delete the rest — does it still work?" |
| How Without Why | No explanation for gains | "WHY does your method work? Can you explain theoretically?" |
| SOTA Chasing | Only metric improvements | "0.5% gain — what insight does this reveal?" |
| Fake Ablation | Only validates own modules | "vs the simplest baseline — is the gap really from your innovation?" |
| Follow-up Paper | Minimal extension | "Would the original authors think this deserves a separate paper?" |

## Soul Questions (for paper-level evaluation)

1. Does this paper solve a REAL problem or a MANUFACTURED problem?
2. After reading, what will the reader CHANGE?
3. In 5 years, how many citations and from which fields?
