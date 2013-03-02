#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use moran; 

my @data1 = ( 2.1, 1.01, 1.02, 9.5, 33, 45, 4, 0.0001,0.001, 0.001, 10, 11, 12, 13,8,5, 4, 5, 7,45, 9);
my @data2 = ( 1, 2, 3, 4, 5, 6, 7, 0, 8,9);
my (@i_min, @i_max, $mean, $sd, $min, $max) = ();

print " @data1\n";
$mean = mean(\@data1);
$sd = standard_deviation_data(\@data1);
print "mean is $mean, std is $sd \n";
     
@i_min = mini(\@data1);
print " min idex are: @i_min\n";
$min= $data1[ $i_min[0] ];
print "The min is $min, significance is ".gaussian2( $min, $mean, $sd)."\n";

@i_max = maxi(\@data1);
$max = $data1[ $i_max[0]  ];
print "The max is $max, significance is ".gaussian2( $max, $mean, $sd)."\n";     
print " max idex are: @i_max.\n";

mergesort_iter(\@data1);
print " @data1\n";

my @histo = getHistogram(\@data1, 2, 0, 50);
print "Two bins: @histo\n";
 @histo = getHistogram(\@data1, 3, 0, 50);
print "Three bins:  @histo\n";
 @histo = getHistogram(\@data1, 5, 0, 50);
print "Five bins:  @histo\n";
 @histo = getHistogram(\@data1, 10, 0, 50);
print "Ten bins:  @histo\n";

print "Value 1, mean 0, std 1, significance is ".gaussian2( 1, 0, 1)."\n";  
print "Value 0, mean 0, variance 5, significance is ".gaussian1( 0, 0, 5)."\n";  
print "Value 0, mean 0, variance 5, significance is ".gaussian2( 0, 0, sqrt(5) )."\n";   

print "Value 3, mean 0, variance 5, significance is ".gaussian1( 3, 0, 5)."\n";
print "Value 3, mean 0, variance 5, significance is ".gaussian2( 3, 0, sqrt(5) )."\n";
