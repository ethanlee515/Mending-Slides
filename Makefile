DECK := mending-slides
BUILD_DIR := build
LATEXMK := latexmk
LATEXMK_FLAGS := -pdf -interaction=nonstopmode -halt-on-error -file-line-error -outdir=$(BUILD_DIR)

.DEFAULT_GOAL := all
.PHONY: all watch clean

all: $(BUILD_DIR)/$(DECK).pdf

$(BUILD_DIR)/$(DECK).pdf: $(DECK).tex $(wildcard diagrams/*.tex slides/*.tex assets/affiliations/*.png assets/ssprove/*.v assets/itp/*.png) | $(BUILD_DIR)
	$(LATEXMK) $(LATEXMK_FLAGS) $(DECK).tex

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

watch: | $(BUILD_DIR)
	$(LATEXMK) $(LATEXMK_FLAGS) -pvc $(DECK).tex

clean:
	$(LATEXMK) -C -outdir=$(BUILD_DIR) $(DECK).tex
