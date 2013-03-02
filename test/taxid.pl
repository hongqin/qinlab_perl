#!/usr/bin/perl -w
use strict;	use lib '/shar/lib/perl/';   use Taxonomy; use Util;


my %species2taxid;
%species2taxid  = get_species2taxid_hash();
showHashTable( \%species2taxid );

my %taxid2species = get_taxid2species_hash();
showHashTable ( \%taxid2species );

my $id = species2taxid("Homo sapiens");
print "$id\n";

print "". taxid2speices(9606). "\n";

exit;


