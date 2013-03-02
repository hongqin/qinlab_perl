#! /usr/bin/perl -w
use strict;	use warnings;
use lib '/shar/lib/perl/';     use Util;

my @lines = ( " red blue\t", "blue yellow \t", "orange red\t", "pink yellow\t",
	"cat dog cow pig human \t", "monkey human tiger\t"  );

print "Before: @lines \n\n";
my @new_lines =  single_linkage_cluster_on_head_list( @lines);
print "After: @new_lines \n";


 my @clusters =  single_linkage_cluster_on_array_of_list( @lines );

 print "Clusters are:\n";
 foreach ( @clusters ) { print "$_\n" }



exit;

