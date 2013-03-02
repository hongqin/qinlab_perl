#! /usr/bin/perl -w
use strict;	use warnings;
use lib '/shar/lib/perl/';     use AA; 

my $cds = "ATG CCC GAA ATT AGA GAG ATT ATT ACA AAA GCA GTG GTT GGA AAA GGA CGT AAG TAT ACA AAG TCA ACT";
my $peptide = "MPEIREIITKAVVGKGRKYTKST";

my @triplets = split ( /\s+/, $cds );
my @AAs       = split ( //, $peptide );

for( my $i=0; $i< $#AAs; $i++) {
 my $num = is_matched_codon_and_aa( $AAs[$i], $triplets[$i] );   
 print "$AAs[$i], $triplets[$i] = $num \n";

}

exit 1;

