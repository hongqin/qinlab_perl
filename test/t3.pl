#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use Align;      use Codon;     
my ($key, $value);

my ( @CDS_align) = (
"tgaactT --atgcagcga", 
"ttacaAa-tctcag---gg");


print "$CDS_align[0]\n$CDS_align[1]\n";  

print countT($CDS_align[0])." ";
print countC($CDS_align[0])." ";
print countA($CDS_align[0])." ";
print countG($CDS_align[0])." \n";

my %pairCount = count16NucPairs(\@CDS_align);

print"\n";
while ( ($key,$value)=each(%pairCount) ) {
  print "$key:$value \t"; 
}
print"\n";


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

print"\n";
while ( ($key,$value)=each(%pairCount) ) {
  print "$key:$value \t"; 
}
print"\n";

