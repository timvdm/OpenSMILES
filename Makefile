all: html pdf

html: opensmiles.asciidoc
	asciidoc -b xhtml11 opensmiles.asciidoc

pdf: opensmiles.asciidoc
	a2x opensmiles.asciidoc


