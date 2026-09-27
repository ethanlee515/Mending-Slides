# Lean demo: infinitude of primes

Reconstructed from `../../lean-demo.png` for the “Lean Demo” frame in
`../slides/itp-background.tex`. The proof follows the screenshot, including
its intermediate claims and tactic steps. The tactic imports are explicit,
and the comment's “contraction” typo is corrected to “contradiction”.

The project pins Lean and mathlib to `v4.30.0-rc2`.
With [elan](https://github.com/leanprover/elan) installed, run from this directory:

```sh
lake update
lake exe cache get InfinitelyManyPrimes.lean
lake env lean InfinitelyManyPrimes.lean
```

Open this directory in VS Code with the Lean 4 extension, then open
`InfinitelyManyPrimes.lean`. Move the cursor through the proof to show how
the hypotheses and goal change. For a live exercise, replace a proof step
with `sorry` and fill it in during the talk; the saved file contains the
complete proof.
