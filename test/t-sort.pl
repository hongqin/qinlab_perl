#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use Util; 

my $s1 = "American"; 
my $s2 = "Germany";
my $s3 = "American-airline";
my $s4 = "American";

my ($bigger, $smaller) =  order_big2small($s1, $s2 );
print "$bigger > $smaller \n";

my ($bigger, $smaller) =  order_big2small($s1, $s3 );
print "$bigger > $smaller \n";

my ($bigger, $smaller) =  order_big2small($s1, $s4 );
print "$bigger > $smaller \n";

rand (time ^ $$ ^ unpack "%32L*", 'ps axww|gzip'); 

my @newdata;
my @data1 = ( "one", "one", "two");
my @data2 = ( "one", "one", "third");
my @data3 = ( "two", "asdfaf", "as", "afs", "hong","anya","one", "one");
my $p = get_first_tandem_repeats_at_even_positions(\@data1);
print " $p @data1\n";
@newdata =  remove_self_pairing_at_even_position(\@data1); 
print " new: @newdata\n\n";

my $p = get_first_tandem_repeats_at_even_positions(\@data2);
print " $p @data2 \n";
@newdata =  remove_self_pairing_at_even_position(\@data2); 
print " new: @newdata\n\n";

my $p = get_first_tandem_repeats_at_even_positions(\@data3);
print " $p @data3\n";
@newdata =  remove_self_pairing_at_even_position(\@data3); 
print " new: @newdata\n\n";
my %pairs = get_pairs(\@newdata);


exit;

