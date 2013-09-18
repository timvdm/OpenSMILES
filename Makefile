all: html pdf

html: opensmiles.asciidoc
	asciidoc -a toc2 -n -b xhtml11 opensmiles.asciidoc

pdf: opensmiles.asciidoc
	a2x opensmiles.asciidoc

website: html pdf
	rm -rf html
	mkdir html
	cp -R images html
	cp -R depict html
	cp docbook-xsl.css html
	cp index.html html
	cp opensmiles.html html
	cp opensmiles.pdf html
	cp robots html
	cp styles.css html
	tar czvf opensmiles.tgz html/*
