# Title page

As usual

(*Not* quantum talk. Crypto and PL.)

# Recap: FHE, why?

Godel prize...

Is quantum resistant.

# Recap: FHE, what?

Diagram?

# Recap: FHE timeline

TODO bring up from last year

# Recap: The LM Attack

TODO

# Recap: The LMSS patch construction

TODO

# Recap: The LMSS patch intuition

```
Dec'(c) = Dec(c) + e'
= m + e(sk) + e'
~ m + e'
```

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

