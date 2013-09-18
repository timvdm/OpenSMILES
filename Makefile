all: html pdf

html: opensmiles.asciidoc
	asciidoc -a toc2 -n -b xhtml11 opensmiles.asciidoc

pdf: opensmiles.asciidoc
	a2x opensmiles.asciidoc


