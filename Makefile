# -*- Mode: Makefile -*-
# Created Thu Aug  4 09:03:50 AKDT 2011
# by Raymond E. Marcil <marcilr@gmail.com>
#
# Makefile for a single-file LaTeX document plus optional BibTeX file.
#
# Comment out the BibTeX run in the `dvi' target if you don't have a
# bibliography.
#
# NOTE: Cygwin's xdvi puts a read lock on the *.dvi file
#       and breaks the build. Haven't found a way around this
#       yet. Setting chmod 666 before/after does not help.
#

RM     = rm -f
LATEX  = latex
BIBTEX = bibtex
DVIPS  = dvips
PS2PDF = ps2pdf

# Determine LaTeX document basename dynamically.
# Rather than hardcoding.
BASENAME = $(shell ls *.tex | sed 's/.tex//g')
# BASENAME = bsdinspect-database

SRC = $(BASENAME).tex
BIB = $(BASENAME).bib
BLG = $(BASENAME).blg
BBL = $(BASENAME).bbl
LOG = $(BASENAME).log
AUX = $(BASENAME).aux
TOC = $(BASENAME).toc
DVI = $(BASENAME).dvi
PS  = $(BASENAME).ps
PDF = $(BASENAME).pdf
LOF = $(BASENAME).lof
LOT = $(BASENAME).lot
OUT = $(BASENAME).out

cycle: clean dvi ps pdf

all: dvi ps pdf

clean:
	$(RM) $(LOG) $(LOF) $(AUX) $(TOC) $(DVI) $(PS) 
	$(RM) $(BBL) $(BLG) $(PDF) $(LOT) $(OUT) *.tmp

dvi:
	$(LATEX) $(SRC)

# Uncomment this entry if there are \citation entries.
#	$(BIBTEX) $(BASENAME)

# Rerun LaTeX again to get the xrefs right.
	$(LATEX) $(SRC)
	$(LATEX) $(SRC)

ps: dvi
# Embed hyperlinks for hyperref package (-z)
# Embed type 1 fonts, optimize for pdf (-Ppdf)
	$(DVIPS) -z -f -Ppdf < $(DVI) > $(PS)
# Embed type 1 fonts.
#	$(DVIPS) -f -Pcmz < $(DVI) > $(PS)
# Embed type 3 (bitmapped) fonts.
#	$(DVIPS) $(DVI) -o

pdf: ps
	$(PS2PDF) $(PS)
