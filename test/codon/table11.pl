#!/usr/bin/perl -w

use strict;	
use lib '/shar/lib/perl'; #for Linux
use Codon;

my $seq= "ATT ATC ATA ATG TTG CTG GTG";    
$seq =~ s/\s+//go;
my $aa =  dna2peptide_table11( $seq );

print "\$seq=$seq\n";
print "\$aa= $aa\n";


exit;

#end of main

