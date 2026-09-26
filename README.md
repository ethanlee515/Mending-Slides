# Mending-Slides

Slides for arXiv:2608.13846, “Verified Pythagorean Composition for Adaptive
Cryptographic Games: Noise Flooding in Homomorphic Encryption”.

The deck currently contains the title page and the FHE/LM/LMSS recap.
Edit `mending-slides.tex`; speaker notes live in `mending-talk-prep.md`.
Later sections of the notes remain a preparation outline.
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
Recap diagrams are editable TikZ in `diagrams/recap.tex`, redrawn from
`../group-meeting-2025`. Original raster figures are retained in
`assets/recap/` as reference material. The neighboring research repositories
are references, not build dependencies.
