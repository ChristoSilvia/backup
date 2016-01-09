SHELL := /bin/sh

SRC := $(wildcard *.tex)
FIGURE := $(figures/*.tex)
PDF := $(SRC:.tex=.pdf)

ifeq ($(OS),Windows_NT)
	pdflatexflags := "-aux-directory=.build"
	figureflags := "-aux-directory=.build/figures"
else
	pdflatexflags := -output-directory=.build
	figureflags := -output-directory=.build/figures
endif

all:
	-mkdir .build
	-mkdir .build/figures
	for t in $(SRC) ; do \
		pdflatex -shell-escape $(pdflatexflags) $$t ; \
	done
	for t in $(FIGURE); do \
		echo $t; \
		pdflatex -shell-escape $(figureflags) $$t ; \
	done
	-rm $(PDF)
	make links


clean:
	-rm $(PDF)
	-rm -rf .build/*

links:
	-rm $(PDF)
	ln -s .build/*.pdf .
	ln -s .build/figures/*.pdf figures/
