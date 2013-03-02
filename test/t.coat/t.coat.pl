#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/home/hqin/lib/perl/';     use Coat; use Util; 

my %coat_BG2name = ();
_set_coat_BG2namehash( \%coat_BG2name );

showHashTable( \%coat_BG2name );


my %coat_Bsu2BG = ();
_set_coat_Bsu2BG_hash( \%coat_Bsu2BG );


my %coat_Bsu2name = ();
set_coat_Bsu2name_hash( \%coat_Bsu2name);


exit;

