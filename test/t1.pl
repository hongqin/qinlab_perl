#!/usr/bin/perl -w
# test the tranlation subroutine on CDS sequence

use strict;	
#use lib '\lib\perl';     # for windows
 use lib '/shar/lib/perl'; #for Linux
use BeginPerlBioinfo;  
use Codon;

my $infile = $ARGV[0];	

my (@lines,$line, $translation);
my $nuc ="";
open (IN, "<$infile"); 	@lines = <IN>; 	close (IN);

shift @lines; #remove the header

foreach my $i(0..@lines-1) {
  $nuc .= $lines[$i];
}
$nuc =~ s/\s+//g;
print "$nuc\n";
$translation = dna2peptide($nuc);
print "\nProtien is:\n$translation \n";

my $four_fold_seq = dna2_4fold($nuc);
print "Fourfold seq is:\n $four_fold_seq\n";

exit;

#end of main

