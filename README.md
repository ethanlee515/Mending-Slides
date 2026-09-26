# Mending-Slides

Slides for arXiv:2608.13846, “Verified Pythagorean Composition for Adaptive
Cryptographic Games: Noise Flooding in Homomorphic Encryption”.

The deck currently contains the title page. Edit `mending-slides.tex`.
Its 16:9 Metropolis styling follows `../quantum-fair-exchange-talk`;
authors and affiliations come from the camera-ready author block in
`../mending/Pythagorean-RHL/main.tex`.

## Build

Install a TeX distribution with pdfLaTeX, latexmk, Beamer, Metropolis,
and microtype, then run:

```sh
make
```

The PDF is written to `build/mending-slides.pdf`. Use `make watch` for
continuous rebuilding and `make clean` to remove generated TeX outputs.
The neighboring research repositories are metadata references, not build
dependencies.
