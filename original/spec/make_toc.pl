#!/usr/bin/perl
#======================================================================
# FILE:		html_toc.pl
# AUTHOR:	Craig A. James
# DESCRIPTION:
#	Searches an HTML document for <h[234]> tags and creates a table
#	of contents. Assumes that each <hN> tag is accompanied by a
#	named anchor with the same section number.  That is, each
#	heading must look like this:
#
#	<a name="2.4.1"></a><h4>2.4.1 Some Title</h4>
#	
# Copyright (c) 2007, Craig A. James
#
# This program may be used under the terms of the GNU General Public
# License version 2.
#======================================================================

use strict;

my @files = 
    qw /
    open-smiles-1-intro.html
    open-smiles-2-grammar.html
    open-smiles-3-input.html
    open-smiles-4-output.html
    open-smiles-5-nonstandard.html
    open-smiles-6-extensions.html
    open-smiles-7-references.html
    /;

my $toc_file = "open-smiles.html";
if (-r $toc_file) {
    rename($toc_file, "${toc_file}~");
}
open(TEMPLATE, "<open-smiles-toc-template.html");
open(TOC, ">$toc_file");
while (my $line = <TEMPLATE>) {
    last if $line =~ m/_CONTENTS_/;
    if ($line =~ m/_DATE_/) {
	my $date = CurrentDate();
	$line =~ s/_DATE_/$date/;
    }
    print TOC $line;
}

foreach my $filename (@files) {
    open(FILE, "<$filename") or die("Couldn't open $filename: " . $!);
    while (my $line = <FILE>) {

	next if ($line !~ m/\<h[234]\>/);
	$line =~ s/[\n\r]*//g;

	my $depth = $line;
	$depth =~ s/^.*\<h([234]).*/$1/;

	$line =~ s/^.*\<h[234]\>(.*)<\/h[234]>/$1/;

	my $section = $line;
	$section =~ s/^([\.0-9]*).*/$1/;
	$section =~ s/\.$//;

	if ($depth == 2) {
	    print TOC "<p class=\"toc_$depth\"><a href=\"$filename\">$line</a></p>\n";
	} else {
	    print TOC "<p class=\"toc_$depth\"><a href=\"$filename#$section\">$line</a></p>\n";
	}
    }
    close FILE;
}

while (my $line = <TEMPLATE>) {
    print TOC $line;
}


sub CurrentDate {
    my ($day, $month, $year) = (localtime())[3..5];
    $year += 1900;	# Not a Y2K problem - Perl just subtracts 1900 from year.
    $month += 1;	# Don't ask me why January is zero...
    if ($month < 10) {$month = "0$month";}
    if ($day   < 10) {$day   = "0$day";}
    return "${year}-${month}-${day}";
}
