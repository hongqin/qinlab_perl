#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/home/hqin/lib/perl/';     use moran; 

my @data1 = ( 2, 1, 5, 9, 11, 23, 55, 0, -1, 5, 4, 5, 7, 9);
my @data2 = ( 1, 2, 3, 4, 5, 6, 7, 0, 8,9);

my @tmp = sort(@data1);
print "     \@data1 = @data1 \n";
print "sort \@data1 = @tmp \n";

my @tmp = sort(@data2);
print "     \@data2 = @data1 \n";
print "sort \@data2 = @tmp \n";

#quicksort_itr(\@data2);
my @data3 = @data1;
mergesort_iter( \@data3 );
print "          \@data1 = @data1 \n";
print "mergesort \@data1 = @data3 \n";

