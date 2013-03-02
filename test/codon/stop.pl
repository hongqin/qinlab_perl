#!/usr/bin/perl -w

use strict;	
 use lib '/shar/lib/perl'; #for Linux
use BeginPerlBioinfo;  use FASTA; use Codon;

my $infile = $ARGV[0];	
my ( $stop_codon_flag, $choice_of_stop ) = ( 1, "TGA" );
my $flag = adjust_last_codons1 ($infile, $stop_codon_flag, $choice_of_stop );     


exit;

#end of main

