# Repository context

This repository contains slides for the project at `~/research/mending`:
“Verified Pythagorean Composition for Adaptive Cryptographic Games:
Noise Flooding in Homomorphic Encryption” (arXiv:2608.13846).

- Follow the slide style of `~/research/quantum-fair-exchange-talk`.
- Find authors and affiliations in the `Pythagorean-RHL` submodule of
  `~/research/mending`, specifically the `CameraReady` block in `main.tex`.
- The talk is a group meeting presentation for Xiaodi Wu’s group. Some
  audience members attended the old talk, but new members have not; do not
  assume knowledge of that talk or any cryptography background.
- Keep slides sparse: diagrams, equations, and short cues. Put explanations
  in the Markdown speaker notes. For the recap, hats denote ciphertexts and
  `k` is the client’s secret key; public/evaluation material is left implicit.
- `mending-talk-prep.md` is the evolving Markdown speaker-notes document;
  transform preparation sections into notes as their slides are developed.
- `../group-meeting-2025/` contains a much older talk by the user; use it
  as a historical reference.
- The slide source is `mending-slides.tex`; recap TikZ diagrams are in
  `diagrams/recap.tex`.
- Use the existing `Makefile` (`make`) to build the PDF into `build/`.
