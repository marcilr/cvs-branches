# -*- Mode: Makefile -*-
#
# A makefile for LaTeX documents, including BibTeX bibliographies.
#
# Copyfnord (K) 3166, 3167, James A. Crippen <james@unlambda.com>

# This makefile can make LaTeX documents, including those with BibTeX
# bibliographies.  It can't do indexes yet unfortunately, nor can it
# do fancy things like different versions of a document (such as you
# might want for submission to different journals).  Perhaps such
# features will be added in the future.
#
# Nota Bene:
#   This depends heavily upon features of GNU Make.  If you don't
#   have GNU Make you should probably get it rather than hacking on
#   this makefile.

# For any particular file FOO.tex you can use any of the following
#
#    make FOO.bbl
#    make FOO.dvi
#    make FOO.ps
#    make FOO.pdf
#
# to make that particular output file.  You can't make aux or toc
# files directly, though making a dvi will cause those files to be
# generated.

# You need to customize the SRCS variable below to point to the LaTeX
# source files (without extensions) for every LaTeX document to be
# generated.  If you have multifile documents you should probably be
# using LaTeX to manage the multiple files and not depend on make to
# get things right.
SRCS=cvs-branches

# Commands
RM = /bin/rm -f

LATEX = /usr/bin/latex
PDFLATEX = /usr/bin/pdflatex
BIBTEX = /usr/bin/bibtex
DVIPS = /usr/bin/dvips -Pcmz

####################################
# No user servicable parts inside. #
# Warranty void if cover removed.  #
####################################

# Phony (non-file) rules.
.PHONY : texclean bibclean mostlyclean clean distclean

# Clear implicit rules.
.SUFFIXES :

# Protect intermediate files from removal.
.PRECIOUS : %.dvi %.bbl %.ps

# Default target.
.DEFAULT : default

# Implicit rules.

%.tex :

# Do something even if bib doesn't exist.
%.bib :
	-test -f $<

# Only make bbl if bib exists.
%.bbl : %.bib
	$(LATEX) $*
	-test -f $< && $(BIBTEX) $*

%.dvi : %.bbl %.tex
	$(LATEX) $*
	$(LATEX) $*

%.ps : %.dvi
	$(DVIPS) -o $@ $<

%.pdf : %.dvi
	$(PDFLATEX) $*

# Default rule.

default : $(SRCS:=.tex) $(SRCS:=.bib) $(SRCS:=.dvi)

# Cleansing rules.

texturds-clean :
	$(RM) *.aux *.toc *.lof *.log

bibturds-clean :
	$(RM) *.bbl *.blg

mostlyclean : texturds-clean bibturds-clean

clean : texturds-clean bibturds-clean
	$(RM) *.dvi *.ps *.pdf

distclean : clean
	$(RM) *~
