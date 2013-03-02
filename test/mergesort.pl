#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/home/hqin/lib/perl/';     use moran; 

my @data1 = ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 12, 14,15);
my @data2 = ( 0, 0, 10, 0, 1,0, 0, 0, 0, 0, 0, 10, 10, 10, 10, 10, 10);
my (@i_min, @i_max) = ();

print " @data1\n";
print "The min is ".min(@data1)."\n";
@i_min = mini(\@data1);  @i_max = maxi(\@data1);
print " min idex are: @i_min\n";
print "The max is ".max(@data1)."\n";     
print " max idex are: @i_max\n";

mergesort_iter(\@data1);
print " @data1\n";
@i_min = mini(\@data1);  @i_max = maxi(\@data1);
print "The min is ".min(@data1)."\n";
print " min idex are: @i_min\n";
print " max idex are: @i_max\n";


my @histo = getHistogram(\@data1, 15, 0, 15);
print "15 bins 0-15: @histo  Actually, ".(scalar @histo)." bins returned.\n";
 @histo = getHistogram(\@data1, 10, 0, 15);
print "10 bins 0-15:  @histo Actually, ".(scalar @histo)." bins returned.\n";
 @histo = getHistogram(\@data1, 5, 0, 15);
print "Five bins 0-15:  @histo  Actually,".(scalar @histo)." bins returned.\n";
 @histo = getHistogram(\@data1, 100, 0, 15);
print "100 bins 0-15:  @histo Actually,".(scalar @histo)." bins returned.\n";  


print " @data2\n";
print "The min is ".min(@data2)."\n";
print "The max is ".max(@data2)."\n";
mergesort_iter(\@data2);
print " @data2\n";


my @histo = getHistogram(\@data2, 10, 0, 10);
print "Ten bins 0-10: @histo  Actually,".(scalar @histo)." bins returned.\n";       

 @histo = getHistogram(\@data2, 10, 0, 9);
print "Ten bins 0-9:  @histo  Actually,".(scalar @histo)." bins returned.\n";       

 @histo = getHistogram(\@data2, 5, 0, 9);
print "Five bins 0-9:  @histo  Actually,".(scalar @histo)." bins returned.\n";       

 @histo = getHistogram(\@data2, 5, 1, 2);
print "Five bins 1-2:  @histo  Actually,".(scalar @histo)." bins returned.\n";       

 @histo = getHistogram(\@data2, 5, 0, 10);
print "Five bins 0-10:  @histo  Actually,".(scalar @histo)." bins returned.\n";       

