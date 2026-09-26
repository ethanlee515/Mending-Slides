# Mending — speaker notes and remaining outline

Group meeting talk for Xiaodi Wu’s group. Some listeners attended the 2025
presentation; new members have not. Introduce the recap without assuming that
previous talk. Speaker notes are maintained here in Markdown alongside the
LaTeX deck, rather than in a second notes PDF.

The title and recap sections below are speaker notes for implemented frames.
Sections from **Main Result** onward remain the preparation outline and will
be turned into speaker notes as we develop those slides. Frame numbers count
logical slides; overlay stages are listed within their slide. Keep the slides
visual and sparse; explain the definitions, qualifications, and transitions
aloud using these notes. Assume no cryptography background.

# Title page

**Slide 1 — title page**

- This is a cryptography and programming-languages talk, rather than a quantum
  algorithms talk. The connection to the group is the verification work.
- Introduce the collaboration using the authors and affiliations on the slide.
- Some of this introduction will look familiar from last year. We will review
  the cryptographic problem before explaining what is now machine checked.

# Recap: FHE, why?

**Slide 2 — Recap: FHE, why?**

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
The slide keeps only the motivation and two short cues. Explain the
client/server roles and the quantum-security qualification aloud.
Source: [2022 Gödel Prize citation](https://sigact.org/prizes/g%C3%B6del/citation2022.html).

# Recap: FHE, what?

**Slide 3 — Recap: FHE, what?**

- Walk through the commuting diagram. The upper row is plaintext computation:
  input `x`, function `f`, output `y`. For exact correctness, `y = f(x)`.
- Encryption takes us to the lower row. The server evaluates an encrypted
  counterpart of `f` on the ciphertext. Decryption takes us back to the output.
- Define hats once: `hat{x}` is an encryption of `x`; `hat{y}` is an encrypted
  output. Hats are this talk’s convention, not a universal cryptographic
  notation. Papers often use `c` or `ct` for ciphertexts. The convention is
  spoken rather than printed on the slide.
- Define `k` as the client’s secret key. Use the simple secret-key interface
  `Enc_k` and `Dec_k`; the server can evaluate without knowing `k`.
- For this one-round picture, treat public/evaluation helper material as bundled
  with the ciphertext sent to the server. It is implicit in `Eval`. There is no
  need to introduce separate public and evaluation keys in the recap.
- The diagram’s lower route is `x → hat{x} → hat{y} → y`. The upper route applies
  `f` directly. Walk through these two routes rather than display another
  three-line definition of the same computation.
- Exact FHE recovers the intended plaintext result. In approximate FHE, such as
  CKKS, we allow a bounded numerical error: `y ≈ f(x)`. Say this aloud; the
  diagram intentionally does not repeat “approximately” on the decryption
  arrow. The only displayed relation, below the centered diagram, is
  `y ≈ f(x)`. The error is the focus of this talk.

**Slide 4 — Recap: FHE, what? — Cloud computing (seven stages)**

1. Establish the client and server.
2. The client generates its secret key: `k ← KeyGen()`.
3. The client encrypts `x`, producing `hat{x}`.
4. The client sends the ciphertext and the computation `f` to the server.
5. The server evaluates `f` on the ciphertext, producing `hat{y}`.
6. The server sends `hat{y}` back.
7. The client decrypts it. Only the client holds the secret key.

Reinforce that the server does the computation while the client holds `k`.
The transmitted `hat{x}` implicitly includes the helper material for evaluation,
created during setup. Key generation happens before encryption and before the
first message to the server.
Next ask what changes when a decrypted result is also revealed to someone else.

Redrawn in `diagrams/recap.tex` from **Homomorphic Encryptions** and the six
**Homomorphic Encryptions and Cloud Computing** frames in
`../group-meeting-2025/main.tex`, with a separate key-generation stage added.

# Recap: FHE timeline

**Slide 5 — Recap: FHE timeline**

- This redraw covers the historical milestones from last year’s talk, rather
  than an exhaustive survey of developments through today. Milestone spacing
  is schematic, not proportional to elapsed years.
- The FHE question goes back to 1978; Gentry’s first construction appeared in
  2009. The 2011–2012 generation of constructions made major efficiency gains.
  “Efficient constructions” means major theoretical efficiency gains, not that
  FHE was already practical for every application.
- CKKS introduced approximate homomorphic arithmetic in 2017.
- Our focus is the sequence at the right: Li–Micciancio’s attack in 2021 and
  the LMSS noise-flooding defense in 2022. The Gödel Prize in that same year
  recognizes efficient FHE constructions, not the LMSS defense.
- Transition: allowing approximate results changes what decryption can reveal.

Redrawn from **FHE Timeline**; the efficiency milestone is labeled 2011–2012
and the two 2022 events share one year marker.

# Recap: The LM Attack

**Slide 6 — Recap: The LM Attack (four stages; one round)**

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
- In the LM threat model, the attacker may choose the plaintext and the
  computation. For this introductory picture, simply say “knows `x` and `f`”;
  the input-selection interaction is implicit.
- One round illustrates the source of leakage. The old second-round arrows
  did not explain a specific attack algorithm and are omitted here.
- Do not claim that every CKKS configuration loses its entire key from one
  released result. The required observations depend on encoding, precision,
  parameters, and the attack. A known/chosen-input attack need not be adaptive;
  the later security theorem protects against general adaptive queries.
- Standard IND-CPA security covers ciphertext observations, not this additional
  decryption-output interface. The formal result later in the talk uses the
  stronger IND-CPAD setting.

Technical background, if asked (off-slide): Section 3 of the USENIX paper below
reconstructs the simplified LM example with plaintext zero and the identity
function. For a raw ciphertext `(a,b)` with `b = a*s + e`, revealing raw
`Dec_s(a,b) = e` exposes `a*s = b-e`. A single such answer recovers `s` when
`a` is invertible. This omits CKKS encoding/decoding and is an illustrative
algebraic example, not a universal practical query count.

Redrawn from the old **The LM Attack** frames, reduced to one round with
explicit known plaintext/function and consistent hat notation.
Sources: [Li–Micciancio, EUROCRYPT 2021](https://eprint.iacr.org/2020/1533);
[Guo et al., USENIX Security 2024, Section 3](https://www.usenix.org/system/files/usenixsecurity24-guo-qian_1.pdf).

# Recap: The LMSS patch construction

**Slide 7 — Recap: The LMSS patch construction**

- Here `hat{x}` denotes the ciphertext being decrypted; `x` is its intended
  plaintext. It can be the evaluated ciphertext previously called `hat{y}`.
- LMSS = Li, Micciancio, Schultz, and Sorrell. Their defense postprocesses
  approximate decryption with fresh Gaussian noise.
- Walk through the `Dec'` procedure: it takes the secret key `k` and a
  ciphertext `hat{x}`, decrypts, samples independent noise, and returns the
  decrypted value plus that noise. The sampling assignment draws from the
  Gaussian distribution, rather than copying a deterministic value.
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

# Recap: The LMSS patch intuition

**Slide 8 — Recap: The LMSS patch intuition**

- Start with the decomposition from the outline:

  ```text
  Dec'_k(hat{x}) = Dec_k(hat{x}) + e'
                 = x + e(k) + e'
                 ≈dist x + e'
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
  argument using a new program logic and a verified compiler.

Adapted from the old talk’s **The Patch** / **Noise Flooding** explanation and
this preparation outline’s equation; the old deck has no separate intuition
frame.

# Main Result

Formally verify the LMSS patch

Constructed new program logic + compiler combo

# Formalization details

* Open source (GitHub link)
* TCB = Rocq/SSProve
* ???
* 30k lines?

# Background: programming language

```py
a = -1
b = -1
def f() -> int:
  global a, b
  a = randint(1, 6)
  b = randint(1, 6)
  return a + b
```
Can you write this down in Rocq Prover or Lean?

No mutable variables.
Deterministic programs only.

For simplicity, for the rest of the talk we omit `M`.

* => Need *embedded language*. i.e. SSProve in Rocq.

# Background: What is a program?

* A string?
* A function?
  * `def f(x : X) -> Y` ~= $Fun(X, \mathsf{distr}(Y))$
  * Semantics, functional programming, computational monad...
  * Here be dragons.
* AST
  * List of instructions
  * Let's take this view today.
  * Denote by $\llbracket c\rrbracket$ the corrresponding function.

# Background: The SSProve `code`

TODO just copy-paste?

# Background: Why program logic

Goal:
```py
r = f()
assert r > 0
```

Proof:
```py
x = randInt(1, 6)
assert x > 0
y = randInt(1, 6)
assert x > 0 and y > 0
r = x + y
assert x > 0 and y > 0 and r = x + y
assert r > 0
```

# Background: Program logic warm-up

Theorem: Data processing inequality.

Let $X, Y, R$ be sets, and $D(x), D'(x) : X -> distr(Y), P(y): Y -> distr(R)$ be random functions.
For all $x in X$, we have
$$\norm{(P \circ D)(x) - (P \circ D')(x)}_1 <\norm{D(x) - D'(x)}_1$$

Now, what if $D$, $D'$, and $R$ are all programs?

# Background: (Relational) judgments

* Judgments = properties of programs.
* i.e. pre/post-conditions.
* We write...

# Backgrond: The `seq` rule as example

TODO

# Pythagorean Preservation of MW

Thm. TODO

Central question: How to capture this in a program logic?

# Our `Pyth` judgment

TODO

# Our sequence rules

TODO

# Our Micciancio-Walter Rule

TODO

# Putting everything together

`Adv^ODec ~ Adv^{ODec'}`

`LHS = A1 ; ODec ; A2 ; ODec ; ... ; Aq`
`RHS = A1 ; ODec'; A2 ; ODec'; ... ; Aq`

So, `LHS ~_{q} RHS`...

Whoops, `A = code`, no extra structure.

# Our compiler

# Compiler correctness

# Game "hops"

# Verified main theorem

` Adv[...] <= Adv[...] + ...`

# Future directions

* Push towards entire CKKS

