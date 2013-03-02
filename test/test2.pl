#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use Align;      use Codon;     

my ( @CDS_align) = (
"tga--tttagcga", 
"-actc45678---");

print "$CDS_align[0]\n$CDS_align[1]\n";  

print "T  C  A  G\n";
print countT($CDS_align[0])." ";
print countC($CDS_align[0])." ";
print countA($CDS_align[0])." ";
print countG($CDS_align[0])." \n";

my @aln_no_gap = removeGaps_in_alignedPair(\@CDS_align);  #!!!!
print "$aln_no_gap[0]\n$aln_no_gap[1]\n";  

print countT($CDS_align[0])." ";
print countC($CDS_align[0])." ";
print countA($CDS_align[0])." ";
print countG($CDS_align[0])." \n";

print countT($aln_no_gap[0])." ";
print countC($aln_no_gap[0])." ";
print countA($aln_no_gap[0])." ";
print countG($aln_no_gap[0])." \n";


