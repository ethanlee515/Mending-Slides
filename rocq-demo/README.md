# Rocq demo: infinitude of primes

This demo accompanies slide 4, “Rocq Demo.” Its checked proof follows the
informal proof on the slide: choose a prime divisor of `n! + 1`, suppose it
is at most `n`, and derive that the prime divides `1`.

## Build and HTML

Validated with Rocq 9.0.1 and MathComp Boot 2.5.0 in the existing `Mending`
opam switch. SSProve is not needed for this elementary example.

From the repository root:

```sh
opam exec --switch=Mending -- make -C rocq-demo
```

If the appropriate switch is already active, `make -C rocq-demo` also works.
For a separate environment, install `rocq-core.9.0.1` and
`rocq-mathcomp-boot.2.5.0` in an opam switch.

The default target first runs `rocq compile` to check the entire proof,
including `Qed`, then uses `rocq doc --light` (formerly `coqdoc`) to produce
`build/proof.html`. Open that file in a browser. Light mode hides proof
bodies and imports, leaving a readable view of definitions and theorem
statements, not an interactive proof session. The slides' “check + render” arrow
represents these two steps. `rocq doc` alone is a formatter and would not
reject an invalid proof; the Makefile prevents rendering when checking fails.

`Print Assumptions infinitude_of_primes` prints “Closed under the global
context”: the theorem uses no axioms or admitted lemmas. To check without
rendering, run `make -C rocq-demo check`. The slide deck builds independently
with the repository's usual `make`; `make demo` builds the checked HTML demo.

## Live presentation

Open `InfinitelyManyPrimes.v` with [VsRocq](https://github.com/rocq-prover/vsrocq)
in VS Code. Its extension and `vsrocq-language-server` need matching versions;
point the extension to your switch's `vsrocqtop` executable. Use manual
proof mode and step through the sentences to show hypotheses and goals.
The `_RocqProject` file suppresses the expected MathComp notation warnings.

Keep the audience's attention on the named mathematical facts, not every
tactic character:

1. `intro n` fixes an arbitrary bound.
2. `pose x := n ! + 1` names the same number as the informal proof.
3. `have [p prime_p p_divides_x] := pdivP x_gt1` chooses a prime divisor.
4. `exists p` chooses our witness; we must still prove `n < p`.
5. The contradiction step introduces `p_le_n`, meaning `p <= n`.
6. `p_divides_factorial` and `p_divides_one` are the two divisibility facts.
7. `p_not_divides_one` conflicts with `p_divides_one`; `Qed` closes the proof.

`n !` is a local spelling of MathComp's factorial notation `n` followed by
backtick-exclamation. `p %| m` means that `p` divides `m`. `prime p`,
comparisons, and divisibility are Boolean predicates; Rocq treats a Boolean
used as a proposition as the assertion that it equals `true`. The line
`rewrite ltnNge; apply/negP` starts the contradiction argument by rewriting
`n < p` as the negation of `p <= n`. `have` records an intermediate fact;
`by` finishes a proof step. These library details need only a brief gloss.

For a live exercise, delete the proof of `p_divides_one`, inspect the goal,
and fill the step back in. To demonstrate rejection, change the final
argument to `reflexivity.`: the proof fails. Restore the complete file
before generating HTML. Avoid leaving `Admitted` in the demo, since that
accepts a missing proof as an assumption.
