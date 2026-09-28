# Mending — speaker notes

Group meeting talk for Xiaodi Wu’s group. Some listeners attended the 2025
presentation; new members have not. Introduce the recap without assuming that
previous talk. Speaker notes are maintained here in Markdown alongside the
LaTeX deck.

Speaker notes below follow the current deck, from the title and ITP
introduction through the cryptographic background, technical development,
and closing. Pinned preparation material remains alongside the relevant notes.
Frame numbers count logical slides; overlay stages are listed within their
slide. Keep the slides visual and sparse; explain the definitions, qualifications, and transitions
aloud using these notes. Assume no cryptography background.

# Title page

**Slide 1 — title page**

- This is a cryptography and programming-languages talk, rather than a quantum
  algorithms talk. The connection to the group is the verification work.
- Introduce the collaboration aloud. Author superscript 1 refers to the left
  emblem (Maryland); superscript 2 refers to the right emblem (Edinburgh).
- Some of this introduction will look familiar from last year. We will review
  the cryptographic problem before explaining what is now machine checked.

# Interactive theorem proving background

**Slide 2 — What is Interactive Theorem Proving?**

Compare the familiar LaTeX workflow to writing a formal proof. The output
icons represent a rendered proof view; HTML is illustrative, not Lean’s
kernel output. The crucial extra step is checking the proof, not its format.

**Slide 3 — Compilation vs. Verification**

LaTeX will happily typeset `0 = 1`. Lean rejects an attempted proof of it
unless inconsistent assumptions or an unproved placeholder have been supplied.
Checking is always relative to the stated axioms; that is the trust story
we will return to later.

**Slide 4 — Lean Demo (two stages)**

Explain the primes proof, then show how a proof assistant checks the steps.
Remember to handle the small `n` cases when making the factorial argument
formal. The slide’s proof is the mathematical sketch.

**Slide 5 — Why Interactive Theorem Proving? (three stages)**

Invite a quick show of hands about errors in papers.
AI can help produce a proof, but the checker supplies the evidence, not the AI.

Soundness is relative to the stated assumptions and the trusted checker.

Transition: now introduce the cryptographic problem whose proof we checked.

# Fully Homomorphic Encryptions

**Slide 6 — Fully Homomorphic Encryptions**

- Fully homomorphic encryption (FHE) lets a server compute on encrypted data
  without holding the decryption key. The client encrypts the input and
  decrypts the output.
- The practical motivation is delegating computation while keeping the input
  private. We will use a client/server picture rather than assume that everyone
  remembers the old talk.
- Efficient FHE constructions received the 2022 Gödel Prize. This is a useful
  indication of the significance of the problem, not a security guarantee.
- Lattice-based FHE is believed resistant to quantum attacks under the relevant
  assumptions. That does not make every use of its decryption outputs safe;
  this distinction will lead into the LM attack.

Ported from the old talk’s **Cryptography** slide, with the cloud-computing
motivation brought forward.
The left side keeps the motivation and two short cues; the upper right holds
the commuting diagram. Explain the client/server roles and the quantum-security
qualification aloud.
Source: [2022 Gödel Prize citation](https://sigact.org/prizes/g%C3%B6del/citation2022.html).

Continue with the diagram on the same slide:

- Walk through the commuting diagram.
- Define hats once: `hat{x}` is an encryption of `x`; `hat{y}` is an encrypted
  output.
- Define `k` as the client’s secret key. Use the simple secret-key interface
  `Enc_k` and `Dec_k`; the server can evaluate without knowing `k`.
- For this one-round picture, treat public/evaluation helper material as bundled
  with the ciphertext sent to the server. It is implicit in `Eval`. There is no
  need to introduce separate public and evaluation keys in the recap.
- The diagram’s lower route is `x → hat{x} → hat{y} → y`. The upper route applies
  `f` directly. Walk through these two routes rather than display another
  three-line definition of the same computation.
- This slide introduces general FHE: the two routes recover the same result.
  Save approximate FHE and numerical error for the timeline and LM attack.

# FHE in cloud computing

**Slide 7 — FHE in cloud computing (seven stages)**

Walk through the messages.
Reinforce that the server does the computation while the client holds `k`.
The transmitted `hat{x}` implicitly includes the helper material for evaluation,
created during setup. Key generation happens before encryption and before the
first message to the server.

# FHE timeline

**Slide 8 — FHE timeline**

- The FHE question goes back to 1978; Gentry’s first construction appeared in
  2009. The 2011–2012 generation of constructions made major efficiency gains.
  “Efficient constructions” means major theoretical efficiency gains, not that
  FHE was already practical for every application.
- CKKS introduced approximate homomorphic arithmetic in 2017.
- Our focus is the sequence at the right: Li–Micciancio’s attack in 2021 and
  the LMSS noise-flooding defense in 2022.
- Transition: allowing approximate results changes what decryption can reveal.

Redrawn from **FHE Timeline**; the efficiency milestone is labeled 2011–2012
with the 2022 marker reserved for the LMSS defense.

# The LM Attack

**Slide 9 — The LM Attack (four stages; one round)**

1. Start with the client/server setting. The attacker knows the original
   plaintext `x` and the function `f` and can observe the ciphertext traffic.
2. The client sends `hat{x}` and `f` to the server.
3. The server returns `hat{y}`.
4. The client reveals the decrypted answer `y`. The coral arrow highlights
   this extra exposure beyond the ciphertext workflow.

- Knowing `x` and `f`, the attacker can compute the intended result `f(x)`.
  The revealed answer gives the residual `y - f(x)`.
- Beneath the centered diagram, the slide writes `y = f(x) + e(k)`, with
  `e(k)` in coral to highlight the secret-key dependence. Explain this aloud
  rather than add a separate error label. This is schematic notation; the
  error also depends on the ciphertext and computation.

Technical background, if asked (off-slide): Section 3 of the USENIX paper below
reconstructs the simplified LM example with plaintext zero and the identity
function. For a raw ciphertext `(a,b)` with `b = a*s + e`, revealing raw
`Dec_s(a,b) = e` exposes `a*s = b-e`. A single such answer recovers `s` when
`a` is invertible. This omits CKKS encoding/decoding and is an illustrative
algebraic example, not a universal practical query count.

Sources: [Li–Micciancio, EUROCRYPT 2021](https://eprint.iacr.org/2020/1533);
[Guo et al., USENIX Security 2024, Section 3](https://www.usenix.org/system/files/usenixsecurity24-guo-qian_1.pdf).

# The LMSS patch

**Slide 10 — The LMSS patch**

- LMSS = Li, Micciancio, Schultz, and Sorrell. Their defense postprocesses
  approximate decryption with fresh Gaussian noise.
- Walk through the `Dec'` procedure.
- Fresh noise, every answer: encryption and evaluation remain unchanged.
- `DG` denotes a discrete Gaussian; `n` is the plaintext dimension and `sigma`
  is the flooding width. The width must dominate the public bound on the
  original approximation error at the desired security level.
- Sample again for every answer. Reusing the same flooding noise is not the
  construction analyzed here.
- The slide uses additive notation for intuition. The formalization supplies
  an integer-vector chart for its abstract plaintext space and samples the
  Gaussian in that chart. Save those interface details for later if needed.

Ported from **The Patch**, using `algorithm` and `algpseudocode` as in the
old talk, with explicit Gaussian width and dimension notation.
Source: [LMSS, CRYPTO 2022](https://eprint.iacr.org/2022/816).

# LMSS intuition

**Slide 11 — LMSS intuition**

- Walk through the displayed decomposition:

  ```text
  Dec'_k(hat{x}) = Dec_k(hat{x}) + e'
                 = x + e(k) + e'
                 ≈ x + e'
  ```

- The small secret-dependent shift is difficult to distinguish inside a much
  wider noise distribution. The comparison distribution is centered at the
  intended message and does not contain the secret-dependent error.
- The last relation is statistical closeness, not equality of individual
  samples. Its strength depends on the error bound and flooding width.
- Flooding consumes numerical precision. We cannot simply say “add enormous
  noise” and ignore the usefulness of the answer.
- One answer is only the starting point. An adversary can adapt the next query
  to previous answers; the security proof must control the accumulated loss.
- Transition to the main result: we now verify this adaptive composition
  argument using a new program logic and compiler.

## Pinned for later: masking intuition and parameter cost

Leave the current intuition slide unchanged for now. At this early point,
say only: wide fresh noise hides the small key-dependent error, costs
precision, and must protect the entire adaptive interaction. Then get to the
main result. The detailed width calculation can follow the verified theorem
or become a backup slide.

- OTP analogy, if useful later: on a finite additive group, adding an
  independent uniform value makes the answer uniform, independent of the
  secret-dependent error **and the intended answer**. This gives perfect
  masking but removes the useful numerical result. There is no uniform
  probability distribution over all integers or reals; bounded-interval
  additive noise without modular arithmetic does not give exact OTP masking.
- Gaussian flooding is a security/precision tradeoff, rather than perfect
  uniform masking. Defer concrete bit budgets until `q`, `n`, and `gamma`
  have been introduced.
- Back-of-envelope calculation from our theorem: to make the additive
  statistical loss at most `delta`, require

  ```text
  gamma >= sqrt(q*n) / (2*delta).
  sigma = max(1, E) * gamma, where E is the public approximation-error bound.
  ```

  For the particular target `delta = 2^(-lambda)`, this gives
  `log2(gamma) >= lambda - 1 + (log2(q) + log2(n))/2` for positive `q,n`.
  This is a derived absolute statistical-loss budget, not automatically the
  paper’s concrete computational “bits of security” convention. The total
  bound also includes the base IND-CPA term.
- TODO before adding numerical examples: locate the LMSS paper’s specific
  back-of-envelope discussion and check its parameterization and security
  convention. Do not quote remembered widths as established numbers.

# Main result

**Slide 12 — Main result (two stages)**

1. The centered card says: “We formally verified the LMSS security reduction
   using Rocq/SSProve.” Give the headline before starting the technical part.
2. Reveal the lower callout: a new Pythagorean program logic and compiler
   make this adaptive security proof checkable.

- Credit the underlying cryptographic reduction to LMSS. Our contribution is
  the checked reduction, logic, compiler, and required probability analysis.
- Transition into the technical part: how do we represent programs and their
  security properties, and how do the logic and compiler check this proof?

Recall the ITP introduction: the proof is written in Rocq and checked by
its kernel; SSProve supplies the cryptographic-program semantics. The next
slide introduces the tools and trust obligations in detail.

Layout reference: the rounded theorem card and progressively revealed callout
in [the deleted QMPC main-theorem slide](https://github.com/ethanlee515/QMPC-SWIA-presentation/commit/1b686d933aef9aa13a8018f27376160d20521db8),
recovered from the parent of that deletion commit. The main card is centered
vertically on the page; its offset callout is below, with a northwest-pointing
tail that stops outside the card. Adapted in `diagrams/results.tex`.

# Formalization details

**Slide 13 — Formalization details (three stages)**

The story is what a reader needs to trust and inspect to be convinced by the
checked LMSS reduction. Reveal the trusted computing base first, then the
logic and compiler checked by Rocq, and finally the audit table. Keep all
three regions stationary across the overlays. Separate three obligations:
the trusted foundations, the meaning and hypotheses of the formal theorem,
and the proof chain checked by the kernel.

- **Trusted Computing Base:** the Rocq kernel and standard library, MathComp
  and MathComp Analysis with their real-number/classical infrastructure, and SSProve’s
  program, heap, package, linking, and subdistribution semantics. This is
  broader than “TCB = Rocq/SSProve”.
- **Audit the specification:** check that the formal scheme interface, IND-CPA
  and IND-CPAD games, noise-flooded construction, concrete reduction, and final
  statement represent the intended cryptographic claim. A kernel check proves
  the written statement; it does not certify that we chose the right model.
- **Audit the assumptions:** the scheme and its correctness/security
  interfaces, the integer-vector noise-coordinate chart, and the flooding
  parameter. In particular, probability-one approximate correctness and
  deterministic base decryption remain hypotheses for a concrete scheme;
  the base IND-CPA winning-probability bound is supplied. These must be
  discharged by an instantiation, not counted as verified CKKS properties.
- **Audit running time separately:** SSProve’s program semantics does not
  model probabilistic polynomial time. This means checking the efficiency of
  the concrete reduction already counted in the table, not adding another
  block of code to the count. It runs the adversary once and adds oracle
  forwarding, table bookkeeping, and discrete-Gaussian sampling; the cost of
  these operations and underlying primitives needs a separate argument.
- **Checked by Rocq:** the new judgments are ordinary Rocq propositions and the
  program-logic rules are proved lemmas. The KL/Gaussian analysis, compiler
  correctness, logic soundness, and game hops are proved dependencies of the
  security theorem, with no local `Admitted` in those results. These are not
  extra proof rules the reader has to accept as axioms.

Source-line counts include blank and comment lines, not typeset wrapping.
The detailed breakdown and regeneration command live in Mending’s README.

The count now includes the local definition bodies needed by the displayed
specification, plus the top-level theorem statement. The new “Misc. helpers”
row includes scheme package wrappers/labels, game and adversary interfaces,
heap locations, vector norm/distance/zero/subtraction, SSProve vector types
and integer conversions, safe table indexing, KL’s definition, module aliases,
and reduction/security-bound wrappers. It excludes proved lemma bodies and
proof-only intermediate games; the kernel checks those proofs. It stops at
Rocq/MathComp/SSProve primitives on the Trusted Computing Base side, rather
than counting their transitive library implementation. This is a measured specification selection,
not a claim that all foundations require only 724 lines of inspection.
Running-time analysis inspects the counted reduction and its primitives;
it is not an additional source-line category.
The 27,987-line artifact figure is separate implementation context.

Dependency detail, if asked (off-slide): the pinned dependency
graph still reaches MathComp Analysis’s upstream
`realsum.__admitted__interchange_psum`. The artifact independently proves the
same statement as `interchange_psum_proved`, whose assumption audit does not
report that upstream lemma. This replacement does not automatically remove
the old assumption from the installed SSProve dependency graph. The manuscript
reports an upstream merge for a subsequent MathComp Analysis release; the
pinned artifact continues to report the inherited assumption until that patch
reaches its dependencies. The repository’s `mending.opam` explicitly pins
MathComp Analysis and experimental reals to 1.16.0 and SSProve to commit
`c6d7d4bc3a0a671c92899aa49dfcfb065d1bdbbd` (despite the package version
being named `dev`).

TODO for a separate session: upgrade the dependency pins to versions containing
the merged proof, rebuild the artifact, and re-run `Print Assumptions` on the
top-level theorem before updating the manuscript’s dependency/assumption report.
An upstream merge alone does not establish the assumptions of this pinned build.

Implementation/reproducibility details, if asked (off-slide):

- The complete artifact is open source at
  [github.com/ethanlee515/mending](https://github.com/ethanlee515/mending).
- The manuscript reports **27,987 lines of Rocq**. This is artifact size, not
  audit-surface size or human engineering effort. It notes that a majority of
  the codebase was written with AI.
- The reported build uses Rocq 9.0.1, SSProve development commit `c6d7d4bc3a`,
  MathComp Analysis 1.16.0, and MathComp algebra tactics 1.2.7.
- A clean build on the authors’ machine took about six minutes with four
  parallel jobs; this is a single reproduction observation, not a performance
  claim. The manuscript refreshes its Rocq excerpts from checked sources.

Transition: the next slides explain what these program definitions and proved
logic rules look like, starting with how a proof assistant represents a
probabilistic, stateful program.

Sources: `../mending/Pythagorean-RHL/mechanization-and-trusted-base.tex`
(“Trusted computing base” and the final audit-surface paragraph),
`../mending/Pythagorean-RHL/appendix-formal-interface-excerpts.tex`, and
`../mending/Pythagorean-RHL/construction-security-setting-and-result.tex`.
These facts describe the paper’s pinned artifact, not today’s latest library
versions.

# Why program logic

**Slide 14 — Why program logic (three stages)**

Ask the audience whether this program can be written directly as an ordinary
pure function. Reveal the answer and effects after the first pause, then the
embedded-language solution after the second. The issue is the two effects: each call
overwrites stored variables and draws fresh random values (dice rolls here).
In cryptographic games, the corresponding state contains keys, ciphertext tables, and counters.

“No” refers to executing those effects directly in a pure mathematical
function, not to whether Rocq or Lean can model them. We could represent state
and distributions explicitly, but want a common language for writing and
reasoning about the programs. SSProve already provides such an embedded
language in Rocq; it is the solution rather than another tool missing these
features. Lean’s executable effectful facilities are also distinct from an
ordinary pure function.

Transition: how does an embedded language let us represent the instructions
inside a proof assistant? Explain programs as data on the next slide, before
introducing their semantics. This infrastructure is background, not our
contribution.

# What is a program?

**Slide 15 — What is a program? (three stages)**

Use the three views as a quick reminder of a compiler course, not a taxonomy
we need to develop. Reveal the string, function, and tree views one by one.
The string view is a plain text file with an extension such as `.py`.
The semantic function is
what the program does. The syntax tree records its instructions and expression
structure. These are views of the same program, not mutually exclusive answers.
Save the choice of syntax-tree representation and the `c` / `⟦c⟧` notation
for the next slide.

The function view needs both effects explicitly: `Mem` means memory, i.e.
the stored global variables. Explain this in words. Thus
an input and initial state determine a distribution over outputs and final
states. The `↦` from `def f` assigns meaning; it asserts neither a bijection
nor a surjection onto all such mathematical functions. Different programs can
have identical behavior, and an ordinary finite language cannot generally
express every arbitrary mathematical state/distribution function.
For SSProve, the precise general semantics uses subdistributions to allow
failed assertions; do not introduce that detail in this overview.

For Lean users, connect syntax nodes to constructors of an inductive type.
The next slide will show how an interpreter assigns meaning to this data.
We do not need parsing details or a survey of operational versus denotational
semantics here.

# Abstract syntax trees

**Slide 16 — Abstract syntax trees**

Use the function body from the preceding example, with `r = a + b; return r`.
The initial `a = b = -1` belongs to its starting state. `r` is a local return
value; the modeled persistent state here consists of the globals `a` and `b`.
The root sequences four statements. Assignment nodes contain expressions;
the addition expression has two children. These edges describe syntax
containment, not control flow. There is no new temporary-variable notation.
This is a schematic AST of the Python example, not SSProve’s exact code type:
SSProve represents effects with continuations and leaves pure computations
inside Rocq. That detail belongs on the next slide.

The box encloses the whole program. The arrow interprets that whole syntax
tree. Its meaning is a function from initial memory to a distribution over
the returned value and final memory. In our example the initial memory has
`(a,b) = (-1,-1)`; `Mem` must allow these negative initial values. The
returned sum is a natural number. The displayed formula applies the semantics
to `(a_in, b_in)`. Read `(r, (a_out, b_out))` as correlated random variables,
with their joint distribution understood from `distr`. This is shorthand for
the joint distribution, not one deterministic output tuple. Concretely,
each `(r, (a, b)) = (i+j, (i,j))` for `i,j` in `{1,…,6}` has probability `1/36`;
the returned sum alone has unequal probabilities. The interpreter defines
this distribution mathematically rather than running random experiments.

We inspect and transform syntax; correctness and security refer to semantics.
Later our compiler transforms program data, and its checked correctness
theorem relates the meanings before and after transformation.

Transition: SSProve gives us its own instruction representation and interpreter.
Next show the small collection of instructions we will use.

# SSProve’s Computational Monad

**Slide 17 — SSProve’s Computational Monad**

Explain this `raw_code`.

We are cheating slightly with the AST picture: this is a computational monad
with continuations, rather than a conventional AST. Pure computations stay in
Rocq. For this talk, brush those differences under the rug and keep the picture
of instructions as data.

# Program logic motivations

**Slide 18 — Program logic motivations (seven stages)**

Ask why the returned value is positive. It is obvious, but if asked to prove
it, we would explain what each line establishes and what remains true from
earlier lines. Show only the goal first, then the code table with “Nothing”.
Reveal each remaining assertion in the right column one by one. The second assignment changes `b`,
not `a`: retaining the earlier fact matters just as much as learning the new
one. We start with no assumptions about the initial memory. Positivity comes
from the samples, regardless of what was stored before the call.

After assigning `r`, first establish `a > 0 and b > 0 and r = a + b`.
Then weaken this to `r > 0`, without executing another instruction: this is
the rule of consequence (`conseq` in EasyCrypt).

The right column contains logical assertions, not additional runtime checks.
For the dice sampler, positivity holds on its entire support; “always” here
means with probability one. The table suppresses the function declaration and
`global a, b` boilerplate from the earlier example.

Program logic makes this reasoning precise: each instruction has a rule, and
sequencing combines the local facts into a property of the whole program.
The rules are proved against the program semantics. Rocq checks the argument;
we do not have to manually expand the whole distribution every time. Calling
it pedantic is a useful intuition, but the value is modular reasoning, not
merely more verbose code execution.

Transition: these before/after assertions are what a judgment records. Our
security proof will compare two programs, so we will need relational judgments
too.

# Preconditions and postconditions

**Slide 19 — Preconditions and postconditions (two stages)**

Introduce the general Hoare judgment first; pause before revealing the `roll`
example. Package the previous walkthrough as one claim. The first braces give the
starting condition, the second the guarantee about the return value and final
memory. `true` means no restriction on initial memory. Read the turnstile as
“the judgment holds”; these are mathematical propositions, not runtime checks.

For `roll`, all samples are positive and it does not fail. In the repository,
Hoare guarantees the postcondition on the support of successful outputs;
it does not itself prove termination or full mass. Keep that distinction
off-slide unless asked.

# Sequencing: Hoare logic

**Slide 20 — Sequencing: Hoare logic**

The rule uses the paper’s `mathpartir` / `inferrule` layout, without a rule
label. Read it from top to bottom: prove the two premises to obtain the
conclusion below the bar. `Mid` is the interface between the proofs: the
first part establishes exactly the condition the continuation needs.
`y ← c; k(y)` samples the result of `c` and feeds it to `k`, carrying memory
through too. The second premise holds for every intermediate value/memory
satisfying `Mid`. Input arguments are suppressed in this schematic notation.
Connect this to keeping `a > 0` while sampling `b` in our walkthrough.

# Crypto Analysis: Data Processing Inequality

**Slide 21 — Crypto Analysis: Data Processing Inequality (two stages)**

Explain the theorem first; then reveal the question about programs.

Composition means: sample `y` from `D(x)`, then sample the output from `P(y)`.
The result is a mixture over the intermediate value, not ordinary composition
of deterministic functions. The output type of the first stage matches the
input type of the second. The same `P` is applied on both sides. Use `≤`, not
strict `<`: identity postprocessing can preserve the distance exactly.

Work with discrete distributions here; the norm is the sum of absolute mass
differences (twice total variation). No proof is needed unless asked.
Postprocessing cannot make the two distributions easier to distinguish.

The question sets up relational reasoning: run two programs and compare their
behavior. The semantics makes a program into the appropriate distribution-valued
function, and sampling/sequencing gives the same kind of composition.
For stateful programs, thread the entire memory as well as the returned value;
a continuation can inspect the memory, so a result-only marginal is not enough.
In SSProve, calls also require matching interfaces and linking. Do not imply
that any two pieces of code can simply be composed regardless of types or
interfaces. We can leave that machinery implicit and use the compatible-program
picture for this talk.

Transition: package these semantic comparisons into relational judgments, so
we can prove them one program fragment at a time.

# Relational judgments: additive error

**Slide 22 — Relational judgments: additive error (five stages)**

Reveal the judgment first, then the initial pair, then the coupling of the
inline program semantics, then its probability guarantee, and finally the
equality-distance consequence. Explain a coupling and the output/final-memory
semantics aloud; the slide has no separate `mu` notation. Pause to explain
each piece before advancing. Budget sign constraints are omitted from this
schematic picture.

We used assertions about one program. Now the precondition relates two initial
inputs/memories and the postcondition relates two final outcomes. A coupling
means choosing correlated outputs while preserving each program’s own output
distribution. We ask for one that makes the postcondition true except with
probability at most `ε`. This is an existential choice for the proof; the two
actual programs do not need to communicate or share runtime randomness.

`ρ` is an input/memory configuration. For this introduction, assume the
programs do not fail and their semantics has full mass. Say this once in words;
then omit completion notation on the slide. This is the full-mass special case
of the repository’s AE judgment, not a changed definition.

If asked: general AE completes missing mass with a failure outcome `⊥`.
`AE_raw` still uses that completed judgment, but lifts the ordinary postcondition
to hold only when both outputs are successful. Failure on either side counts
against the error budget, even simultaneous failure, so raw AE does not remove
the issue. We postpone this bookkeeping rather than introducing it here.

Bridge back to data processing: with equal starting configurations and equality
of final outcomes, this is exactly a TVD bound on the two output distributions. A coupling
with disagreement at most `ε` implies TVD at most `ε`; conversely a maximal
coupling achieves the TVD for these discrete distributions. Equality of the
full outcomes includes final memory. If we compare just returned
values, use their projections; that gives a
bound on the return distributions rather than on the whole memory state.
The slides use L1 distance consistently: it is twice TVD, so the equality
postcondition yields `||μ_L - μ_R||₁ ≤ 2ε`. The AE error itself remains `ε`.

The general pre/postconditions let us maintain relationships between different
memories and intermediate values. This is why the judgment supports stepping
through and composing program fragments, rather than only comparing final
answer distributions.

# Sequencing: additive error

**Slide 23 — Sequencing: additive error**

Use the paper’s `inferrule` layout without a rule label or takeaway box.
Same structure, now comparing two executions. `Mid` relates the intermediate
values and memories, so the continuation proofs apply to the coupled outputs.
The first coupling can miss `Mid` with probability at most `ε₁`; when `Mid`
holds, the continuation coupling can miss `Post` with probability at most
`ε₂`. Combining the couplings gives error at most `ε₁ + ε₂`.

Keep the full-mass/no-failure picture from the AE introduction. The actual
`additiveErrorSeqRule` uses `AE_raw` for its first premise, ensuring that failure
cannot be a successful intermediate outcome fed to a continuation; the second
premise and conclusion use completed AE. No need to expose that bookkeeping
on this slide.

Transition: ordinary additive-error sequencing pays by adding errors at each
step. Our later judgment retains KL information so we can convert once at
the end instead.

# FHE Analysis: Pythagorean Preservation

**Slide 24 — FHE Analysis: Pythagorean Preservation (two stages)**

Explain the lemma first; then reveal the question about program logic.

Read the coordinates as steps in a transcript, and `a` as the entire history
before the current step. Both distributions are conditioned on the same
history. This is a bound on conditional KL, not merely on unconditional
coordinate marginals; the coordinates need not be independent.

The chain rule adds those KL costs, and Pinsker converts the sum once to
L1 distance: `||P-Q||₁ ≤ sqrt(2 sum_i s_i)`. This is twice the paper’s TVD
bound; the underlying result and security-loss constants are unchanged.
Data processing also bounds the final-coordinate marginal by the same quantity.
This is the probability lemma behind the better composition rate: contrast
one square root of the sum with adding a square root at each step.

Finite KL includes absolute continuity and summability in our discrete
formalization; history-zero cases have a formal conditioning convention.
No need to develop that technical machinery aloud unless asked. The bound
uses natural logarithms.

Now ask how to capture this transcript structure and these conditional costs
inside a judgment for SSProve programs.

# Our Pythagorean judgment

**Slide 25 — Our Pythagorean judgment (five stages)**

The judgment packages the hypotheses of the probability lemma as a property
of two programs. The final transcript marginals are the actual program
outputs. Each coordinate has a conditional KL budget; these costs remain a
vector instead of being immediately converted to a distance. The slide omits
the nonnegative-budget and nonempty-transcript side conditions; the paper
and Rocq definition give the precise statement.

Unlike AE’s relational postcondition, `Post` here is a common unary invariant:
it holds on every successful output of either program. `Pre` still relates
the two initial configurations. This invariant supplies facts needed by later
program fragments. Explain that difference briefly rather than implying the
two judgments have identical postcondition types.

The indexed families `P = {P_i}` and `Q = {Q_i}` are shorthand for the
coordinates of joint transcript witnesses. They retain order and dependence;
we are not choosing independent marginal distributions. `P_n` and `Q_n`
denote their final marginals.

These transcripts are mathematical witnesses, not necessarily the literal
list of syntactic sampling sites. A whole fragment can occupy one coordinate;
the sequence rule will concatenate witnesses. We retain the no-failure picture
here. The formal definition uses completed, encoded output/heap states and
checks `Post` on the support of successful outputs.

Reveal the judgment/cost vector first, then the transcript witnesses, then
the final-marginal identities, then the conditional KL bound, then the common
postcondition. Pause to explain each piece before advancing.

`finiteKL` is omitted from the slide, not from the definition. It carries the
absolute-continuity and summability requirements of the probability lemma.
We are expressing the required hypotheses, not assuming a new trusted rule.

# Micciancio-Walter Rule

**Slide 26 — Micciancio-Walter Rule**

The slide uses an unlabeled `inferrule`; its title names the rule.
This is what the new judgment buys us: the probability lemma bounds the final
output distance, and maximal coupling gives an AE equality judgment. `Post`
is the common invariant from Pyth; the conclusion guarantees equality except
with probability at most `sqrt(||s||₁/2)`.

This error is a disagreement probability, so the constant is still `/2` even
though the previous probability slide displays L1 distance. The equivalent
L1 bound is `sqrt(2||s||₁)`. No normalization change to the AE judgment.

Next: how do we build the vector of KL budgets without paying a square root
at every step? Show the main sequencing rule.

# Sequencing: Pythagorean

**Slide 27 — Sequencing: Pythagorean**

Use the familiar two-premise `inferrule` shape without a rule label or
takeaway box. Keep the symbols in the rule; explain `Mid⁼` and `++` aloud
instead of displaying their definitions below it.
The intermediate postcondition here is a
common unary invariant. `Mid⁼` in the continuation premise requires identical
intermediate values and memory satisfying that invariant. This is not a claim
that the two prefix runs necessarily produce equal outputs: the continuation
comparison is required for each common history, as in the conditional KL lemma.

`++` concatenates the witness transcripts and their KL budget vectors. We do
not add square roots during composition. After composing all fragments,
Micciancio–Walter converts the sum of KL costs once to an AE error.

The other named sequencing lemmas in `Pyth.v` are `pythAeSeqRule` (a shared
continuation), `pythHoareSeqRule` (a shared prefix), and
`pythClosedHoareSeqRule` (the closed-program prefix wrapper). That is four
named lemmas in this file, not a count of every sequencing-related result
throughout the repository. Mention shared code as zero-cost coordinates when
we need it, rather than showing all these statements now.

# Putting the rules to work

**Slide 28 — Putting the rules to work (three stages)**

First show the tempting paper proof. If we already had the adversary factored
around its decryption calls, use Pyth sequencing to accumulate one KL budget
per call and treat unchanged surrounding code as zero-cost. First show the
round decomposition, then reveal the Pyth judgment and its vector, including
the zero-cost fragments. Finally reveal the pink `raw_code` callout.
Its norm is `qε`; MW then gives AE error `sqrt(qε/2)`, which can be recalled
in words instead of displaying another judgment here.
The `A_i` are adaptive continuations depending on prior answers, not fixed
independent computations. The notation is schematic; assume the common
invariant `I`, compatible types/interfaces, and at most `q` selected calls.
In the application, the two decryption oracles are real flooded decryption and
its plaintext-centered simulator, not flooded versus unflooded decryption.

“Whoops: A is raw_code, with no extra structure” means no supplied round
factorization, not that its inductive syntax is unstructured. We are given
an arbitrary SSProve program, not a list of
rounds. Its calls and arguments depend on answers; selected decryption calls
may be interleaved with other operations. `raw_code` has inductive structure,
but does not supply this particular bounded selected-call decomposition.
We need to construct that view and prove it preserves the original behavior.
That is the second contribution’s role: a verified adapter from arbitrary
adaptive oracle code to the sequence our new logic can handle.

Transition: we need an adapter from arbitrary code to this call-by-call proof
view. Recall the computational monad and explain the compiler's goal first.

# From code to decryption rounds

**Slide 29 — From code to decryption rounds**

The compiler is the adapter between the program representation and the proof
view on the previous slide. The left column reuses slide 17’s Rocq listing
style, with constructor arguments replaced by ellipses. The result-type
parameter is called `T` to distinguish it from the adversary `A`; the
arrow labeled “compile” leads to a single-line round decomposition. This is an abbreviated
display, not a compilable declaration. With the full constructor types restored,
Rocq 9.0.1 accepts the bare type binder but infers `Type`; the actual
SSProve definition explicitly requires `choiceType`. The compact slide
omits that detail.
The constructors carry continuations; the program
can branch, sample, use memory, and interleave other calls. None of this gives
us a supplied list of decryption rounds. Expose up to `q` calls to the selected
operation, keeping the adaptive continuations and the ordinary code between
calls. A program can finish before `q` calls; do not insert dummy queries.

The essential correctness requirement is the same output and final-memory
distribution when all calls use the original oracle implementation. This lets
us reason about the exposed program and transfer the result to the original.
It is a proof-oriented transformation, not an optimization or restriction on
the adversary. Here decryption is selected; the paper construction is generic
in the selected operation.

# Compiler intuition

**Slide 30 — Compiler intuition (two stages)**

The first query is `c1` if `b`, otherwise `c2`. After exposing that call,
the remaining program calls `Dec(c2)` only on the true branch; otherwise it
is done. No dummy query is needed. Call results are unused in this example;
in general, the continuation and its later queries can depend on the answer.
The compiler repeats this transformation up to `q` times, so the adversary
does not need to arrive already divided into rounds.

# Run until the next call

**Slide 31 — Run until the next call**

This routine is an effectful program: the prefix's samples, memory operations,
and other calls happen when it runs, not while constructing the compiler.
The pseudocode groups the ordinary constructors together. Reads and samples
supply a value to their continuation; writes have a value-free continuation.
It follows the realized branch and stops before executing the selected call.
A continuation includes the rest of a block and what comes after it, so there
is no unfinished imperative block to manage separately.

For this pseudocode, pretend continuations are serializable and nothing
fails. This is the conceptual monad picture, not a literal implementation.

# Our compiler

**Slide 32 — Our compiler**

Compile returns program data. The inline match runs Next when that program
runs, including the ordinary prefix effects. At a query, execute one
decryption and recursively compile the continuation chosen by its answer.
Done stops early; zero remaining rounds leaves the tail unchanged. We are
still assuming serializable continuations and ignoring failures.

# Main result, revisited

**Slide 33 — Main result, revisited (two stages)**

This slide is drafted in `slides/main-result-recap.tex` and stays after the
technical section as that section grows.

- Return to the result announced earlier, now using the game and program
  notation introduced during the technical part.
- Start with the hypotheses: an approximately correct base FHE scheme with a
  supplied IND-CPA security bound. For every adaptive `q`-query adversary `A`,
  the checked construction produces the reduction `B_{A,q}`.
- Read the displayed bound as “the attacker’s winning probability against the
  flooded scheme is at most the base-encryption bound plus the flooding loss.”
- `beta_CPA` bounds the reduction’s **winning probability**, not a normalized
  advantage. Do not silently replace it with an advantage bound or add an
  extra factor of two.
- `q` counts decryption queries, `n` is the noise-coordinate dimension, and
  `gamma > 0` is the flooding-width multiplier. Flooding uses
  `sigma = max(1, E) * gamma` for public error bound `E`.
- Connect the result to the tools just explained: conditional KL budgets add
  in the Pythagorean program logic; the compiler lifts the local oracle rule
  to arbitrary adaptive programs; one final conversion to statistical distance
  gives the square-root loss.
- After explaining the mathematical bound, reveal the verification box.
  Explain `q`, `n`, and `gamma` aloud rather than listing them on the slide.
- Both the program logic and compiler correctness are formally verified:
  the logic's rules are proved against SSProve semantics, and compilation
  with the original oracle preserves the output/final-memory distribution.
  The reduction using these tools is also checked in Rocq/SSProve.
- An ordinary per-query statistical-distance hybrid bound scales linearly in
  `q`. Preserving KL until the end gives the parameter-critical square root,
  matching the paper’s abstract.

Exact statement from the manuscript:

```text
Pr[IND-CPAD_{NF_gamma[S], q}(A) = 1]
    <= beta_CPA(B_{A,q}) + sqrt(q * epsilon_nf / 2)
    <= beta_CPA(B_{A,q}) + sqrt(q*n) / (2*gamma),
epsilon_nf = n / (2*gamma^2).
```

The theorem also assumes deterministic base decryption with probability-one
approximate correctness and the integer-vector noise-coordinate interface.
Its adversaries are well-typed SSProve oracle programs; polynomial-time
preservation is a separate metatheoretic audit. This is a conditional reduction
for an abstract FHE scheme, not an unconditional verification of all of CKKS.
Keep those precise qualifications available in the spoken explanation.

Sources: `../mending/Pythagorean-RHL/main.tex` (abstract) and
`../mending/Pythagorean-RHL/construction-security-setting-and-result.tex`
(“Checked noise-flooding reduction”). Credit LMSS for the underlying reduction
and the existing square-root composition principle.

# Future directions

**Slide 34 — Future directions**

The two bullets give the next steps: instantiate the underlying IND-CPA
scheme with CKKS, and address the heuristics used in its analysis.
The reduction is conditional on the abstract FHE assumptions; it does not yet
verify CKKS end to end. To instantiate it, account for bad keys/encryptions
with an up-to-bad argument, and connect CKKS's plaintext ring and norm to the
abstract distance-and-translation interface. Then prove CKKS itself is IND-CPA
secure and approximately correct. Rounding is a challenge: randomized and
deterministic rounding differ, and practical deterministic variants can rely
on heuristics that need precise statements before formalization.

# Closing

**Slide 35 — Thank you!**

Open the floor for questions.
