#!/usr/bin/perl -w

use strict;	use lib '/shar/lib/perl/';   use Taxonomy;

my $infile = "taxonomy_input";	
my ( @lines, $line, $all_in_one_line, @records, @new_lines ) = ();

open ( IN, "<$infile"); @lines = <IN>; close (IN);
$all_in_one_line = join ( '', @lines );
@records = split ( /_______\n/, $all_in_one_line ) ;

my @Sce_records = grep ( /Sce:/, @records );
foreach my $record ( @Sce_records ) {
  print "\n--------------------------------\n";
  @new_lines = split ( /\n/, $record );
  foreach $line ( @new_lines ) {
 	if ( hit_eubacteria_beta($line) eq 'YES' ) { print "eubacteria: $line\n"; }
	elsif ( hit_hyperthermo_bac($line) eq 'YES' ) { print "hyperthermo_bac: $line\n"; }
	elsif ( hit_crenarchaeota($line) eq 'YES' ) { print "crenarchaeota: $line\n"; }
	elsif ( hit_euryarchaeota($line) eq 'YES' ) { print "euryarchaeota: $line\n" }
	else { print "no match: $line\n" }
  }
}



exit;

#end of main

