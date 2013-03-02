#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use Align;      use Codon;    use Util; 
my ($key, $value);
my (%codonFreq1, %codonFreq2, %totalFreq);

my ( @CDS_align) = (
"aaaatgccgcgaatgaaaaacaagataatcccaccctga",
"ttacaAa-tctcag---gggc------------------");

my $dna2 ="aaaatgccgcgaatgaaaaacaagataatcccaccctgaaaaatgccgcgaatgaaaaacaagataatcccaccctga";

print "$CDS_align[0]\n$CDS_align[1]\n";  

print "T  C  A  G\n";
print countT($CDS_align[0])." ";
print countC($CDS_align[0])." ";
print countA($CDS_align[0])." ";
print countG($CDS_align[0])." \n";

my %pairCount = count16NucPairs(\@CDS_align);
%codonFreq1 = countEachOf64Codons($CDS_align[0]);
%codonFreq2 = countEachOf64Codons($dna2);
%totalFreq = mergeCounts(\%codonFreq1, \%codonFreq2);
 
print "---------First----------------------------\n";   
showHashTable2(\%codonFreq1, 0.5);   
print "---------Second----------------------------\n";   
showHashTable2(\%codonFreq2, 0.5);
print "---------Total----------------------------\n";   
showHashTable2(\%totalFreq,0.5);
print "-------------------------------------\n";   
showHashTable2(\%pairCount,0.5);   


my @aln_no_gap = removeGaps_in_alignedPair(\@CDS_align);  #!!!!
print "$aln_no_gap[0]\n$aln_no_gap[1]\n";  

print "T  C  A  G\n";
print countT($CDS_align[0])." ";
print countC($CDS_align[0])." ";
print countA($CDS_align[0])." ";
print countG($CDS_align[0])." \n";

print countT($aln_no_gap[0])." ";
print countC($aln_no_gap[0])." ";
print countA($aln_no_gap[0])." ";
print countG($aln_no_gap[0])." \n";

showHashTable(\%pairCount);

