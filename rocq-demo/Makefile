ROCQ ?= rocq
SOURCE := InfinitelyManyPrimes.v
BUILD_DIR := build

.DEFAULT_GOAL := html
.PHONY: check html clean

# Always check before rendering: rocq doc alone does not verify proofs.
check:
	$(ROCQ) compile -w -notation-overridden $(SOURCE)

html: check
	mkdir -p $(BUILD_DIR)
	$(ROCQ) doc --html --light --utf8 --no-index --no-lib-name -o $(BUILD_DIR)/proof.html $(SOURCE)

clean:
	rm -f InfinitelyManyPrimes.vo InfinitelyManyPrimes.vos InfinitelyManyPrimes.vok InfinitelyManyPrimes.glob .InfinitelyManyPrimes.aux
	rm -rf $(BUILD_DIR)
