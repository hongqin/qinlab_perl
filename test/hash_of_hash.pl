#! /usr/bin/perl -w
# unfortunately, the dynamic allocation of hash_of_hash is not successful.

use strict;	use warnings;
use lib '/shar/lib/perl/';    use  Util;

my @keys = qq{ 000, 001, 010, 011, 100, 101, 110, 111 };

my $hoh = { };

foreach my $key1 (@keys) {
  foreach my $key2 (@keys) {
    $hoh{$key1}{$key2} = 0;
    print $hoh{$key1}{$key2}; print "\t";
  }
  print "\n";
}



exit;


