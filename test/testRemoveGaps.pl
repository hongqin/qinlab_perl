#! /usr/bin/perl -w


use strict;	use warnings;
use lib '/shar/lib/perl/';     use Align;           


my ( @CDS_align) = (
"aga--tttagaga", 
"-act345678-90");

open (OUT0, ">nogap.nuc");


my @aln_no_gap = removeGaps_in_alignedPair(\@CDS_align);  #!!!!


print OUT0 "@aln_no_gap";  

close (OUT0);

