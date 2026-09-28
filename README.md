# Mending-Slides

Slides for arXiv:2608.13846, “Verified Pythagorean Composition for Adaptive
Cryptographic Games: Noise Flooding in Homomorphic Encryption”.

The deck contains the title page, ITP introduction, FHE/LM/LMSS background,
main-result headline, formalization details, program-logic and compiler slides,
detailed results recap, future directions, and closing.
Edit `mending-slides.tex` and the included files in `slides/`; speaker notes
live in `mending-talk-prep.md`. Insert further technical slides before
`slides/main-result-recap.tex` and update the corresponding notes.
This is a group meeting talk for Xiaodi Wu’s group, including new members.
Its 16:9 Metropolis styling follows `../quantum-fair-exchange-talk`;
authors and affiliations come from the camera-ready author block in
`../mending/Pythagorean-RHL/main.tex`.

## Build

Install a TeX distribution with pdfLaTeX, latexmk, Beamer, Metropolis,
microtype, TikZ, algorithm, and algpseudocode, then run:

```sh
make
```

The PDF is written to `build/mending-slides.pdf`. Use `make watch` for
continuous rebuilding and `make clean` to remove generated TeX outputs.
The main-result layout is in `diagrams/results.tex`, adapted from the
[QMPC theorem slide deleted in commit 1b686d9](https://github.com/ethanlee515/QMPC-SWIA-presentation/commit/1b686d933aef9aa13a8018f27376160d20521db8).
Recap diagrams are editable TikZ in `diagrams/recap.tex`, redrawn from
`../group-meeting-2025`. Original raster figures are retained in
`assets/recap/` as reference material. The neighboring research repositories
are references, not build dependencies.

The formalization-details slide summarizes Appendix E's excerpt counts.
Reproduce the measurement with
`python3 ../mending/Pythagorean-RHL/scripts/count-interface-excerpts.py`.
The paper's Makefile regenerates its full table during the manuscript build;
the slide keeps a grouped local copy so this deck builds independently.

The opening ITP slides use Rocq, with a two-step “check + render” workflow
for the HTML proof view. The infinitude-of-primes demo is in
[rocq-demo/InfinitelyManyPrimes.v](rocq-demo/InfinitelyManyPrimes.v).
Run `make demo` to check it and generate `rocq-demo/build/proof.html`.
See [rocq-demo/README.md](rocq-demo/README.md) for dependencies and live
presentation instructions. The demo's Rocq dependencies are separate from
the LaTeX slide build.
