OUT_DIR=output
IN_DIR=markdown
STYLES_DIR=styles
STYLE=chmduquesne

all: html pdf

pdf: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.pdf; \
		pandoc \
		  --standalone \
			--template $(STYLES_DIR)/$(STYLE).tex \
			--from markdown \
	    --to context \
			--output $(OUT_DIR)/$$FILE_NAME.tex $$f > /dev/null; \
		mtxrun --path=$(OUT_DIR) --result=$$FILE_NAME.pdf --script context $$FILE_NAME.tex > $(OUT_DIR)/context_$$FILE_NAME.log 2>&1; \
	done

html: init
	for f in $(IN_DIR)/*.md; do \
		FILE_NAME=`basename $$f | sed 's/.md//g'`; \
		echo $$FILE_NAME.html; \
		pandoc \
	    --standalone \
			--include-in-header $(STYLES_DIR)/$(STYLE).css \
      --template=$(STYLES_DIR)/resume-template.html5 \
			--lua-filter=pdc-links-target-blank.lua \
			--from markdown \
			--to html \
			--output $(OUT_DIR)/$$FILE_NAME.html $$f; \
	done

init: dir

dir:
	mkdir -p $(OUT_DIR)

clean:
	rm -f $(OUT_DIR)/*
