#!/usr/bin/perl -w

use strict;	use warnings;
use Graph;
use lib '/shar/lib/perl/';   use Util;

my $g = Graph->new;

$g->add_vertex ( 'a', 'c', 'd' );
$g->add_edge ( 'a', 'c');

print "g = $g\n";

exit;

