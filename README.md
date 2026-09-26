# Mending-Slides

Slides for arXiv:2608.13846, “Verified Pythagorean Composition for Adaptive
Cryptographic Games: Noise Flooding in Homomorphic Encryption”.

The deck currently contains the title page, FHE/LM/LMSS recap, a main-result
headline, and a detailed results recap.
Edit `mending-slides.tex`; speaker notes live in `mending-talk-prep.md`.
The technical section is still an outline. Insert its slides after the
main-result headline and before `slides/main-result-recap.tex`.
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
