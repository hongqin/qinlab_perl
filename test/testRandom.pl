#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use moran;

my @data = ( 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);

srand (time ^ $$ ^ unpack "%32L*", 'ps axww|gzip'); 

my @random = permutate(\@data);
print "Original: @data \n";
print  "Radom1: @random \n";

@random= permutate(\@data) ;
print  "Radom2: @random \n";
@random= permutate(\@data) ;
print  "Radom3: @random \n";
@random= permutate(\@data) ;
print  "Radom4: @random \n";

@data = ( 'one', 'two', 'three', 'four', 'five', 'six');      
@random= permutate(\@data) ;
print  "Radom2: @random \n";
@random= permutate(\@data) ;
print  "Radom3: @random \n";
@random= permutate(\@data) ;
print  "Radom4: @random \n";



my @array = randomIntergerSet(10,20, 10);
print "@array";
print "\n";

 @array = randomIntergerSet(0,10, 11);
print "@array";
print "\n";

 @array = randomIntergerSet(0,10000, 10001);
print "@array";
print "\n";


