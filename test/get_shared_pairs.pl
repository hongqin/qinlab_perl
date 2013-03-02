#!/usr/bin/perl
# get_shared_pairs.pl  
# First version May 24, 2002 Hong Qin

# Precoditions:
# Two input file with pairs of indentification words, such as pair parsed out from blastall output

# Output:  the shared pairs between the two files ( e.g. reciprocal best hit).

# Strategy:
# Readi the pairs into two hashtables, then Util.pm to get the shared pairs

use strict; use warnings; 
use lib '/shar/lib/perl/';     use BeginPerlBioinfo;  use Util;

# Declare and initialize variables
my $infile1 = $ARGV[0];   my $infile2 = $ARGV[1];  my $outfile = $ARGV[2];

if (! $ARGV[2]) {
   print "Usage perl $0 infile1 infile2 outfile \n";
   exit(0);}

# my $debug = 1;  my ($n, $i)= (0,0); 
my (%hash1, %hash2, @lines ) = ();

@lines = get_file_data($infile1);
print "There are ".scalar(@lines)." lines.\n";
set_hash(\%hash1, \@lines, "\t");

#showHashTable(\%hash1);
 @lines = get_file_data($infile2); 
print "There are ".scalar(@lines)." lines.\n";
set_hash(\%hash2, \@lines, "\t"); 

my %shared_pairs = get_shared_pairs( \%hash1, \%hash2 );   

showHashTable(\%shared_pairs);    

write_hash2file(\%shared_pairs, $outfile, "\t");

exit;
