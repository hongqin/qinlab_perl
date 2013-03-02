############################################################
# subroutines for managing yeast data
# Hong Qin
# To use this module, put following lines
#  use lib '/shar/lib/perl/';     use Yeast; 
#
############################################################


############################################################
# Date:	Aug 27 02,	Author: Hong Qin
# Usage: $answer = is_SGD_orf($id1, [$id2], ... ...);
# Description:
#	return 1 if ALL $ids are SGD orf identifiers
#	return 0 otherwise
# Depends on file 'Orf2Name_SGD.tab'.  This file is generated from 
#	the orf and name fields in the headers of file 'orf_trans.fasta'
#	download from SGD.
# Calls Util::parse_dictionary()
# Note: This is a slow and primitive implementation
# Tested in ?
# Usded in 'curagenNameOrfTranslation.pl', but abadon due to excess file IO

sub is_SGD_orf {
 use strict; use warnings; 
 use Util;
 my $debug = 1;
 my $answer = 1;
 my $dic_file = '/home/hqin/lib/perl/Orf2Name_SGD.tab';  # hard link
 my @ids = @_; 

 my %dictionary = ();
 my $flag = parse_dictionary(\$dic_file, \%dictionary);

 foreach my $id (@ids) {
  if (! (exists $dictionary{$id}) ) {
    $answer = 0;  
    return $answer;
  }
 }
 return $answer;
}



##############################################################
1;

