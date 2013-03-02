#!/usr/bin/perl -w
# test the tranlation subroutine on CDS sequence

use strict;	use lib '/shar/lib/perl/';     use BeginPerlBioinfo;  
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


#end of main

sub dna2_4fold{
  my ($dna) = @_;
  my $result ="";
  my $codon ="";
  my $debug =1;

  for (my $i=0; $i< (length($dna)-2); $i+=3) {
    $codon = substr($dna, $i, 3);
    if ( codon_is_nfold($codon) == 4) {
      $result .= substr($codon, 2, 1);
      if($debug) {
	print "$codon-->";
	print codon2aa($codon)."\t";
      }
    }
  } 
  return $result;
}
