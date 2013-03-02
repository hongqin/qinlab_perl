#!/usr/bin/perl
# tbase.pl
# test the base conversion in perl

my @categories_b = ();
my @categories_d = ();
for my $i ( 0.. 127 ) {
#  $categories_b[$i] = sprintf '%b', $i;
  $categories_b[$i] = sprintf '0b%b', $i;
  $categories_d[$i] = sprintf '%d',  $categories_b[$i] ;
  print "$categories_b[$i] \t $categories_d[$i]\n";
}




exit(0);

