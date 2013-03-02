#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use moran; 

my @scores= qw(40 53 77 49 78 20 89 35 68 55 52 71);
print " @scores\n";
print percentile(\@scores, 90), "\n";
mergesort_iter(\@scores);
print " @scores\n";
print percentile(\@scores, 90), "\n";


my @data1 = ( 2.1, 1.01, 1.02, 9.5, 11, 23, 55, 0.001, -0.001, 5, 4, 5, 7, 9);
my @data2 = ( 1, 2, 3, 4, 5, 6, 7, 0, 8,9);


print " @data1\n";
mergesort_iter(\@data1);
print " @data1\n";
print percentile(\@data1, 90), "\n";


print " @data2\n";
mergesort_iter(\@data2);
print " @data2\n";
print percentile(\@data2, 90), "\n";

