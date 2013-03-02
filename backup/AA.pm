############################################################
# subroutines for editing Amino Acids
# Hong Qin
# To use this module, put following lines
#  use lib '/shar/lib/perl/';     use AA; 
#
############################################################

BEGIN { unshift(@INC,"/home/hqin/shar/lib/perl/");   }     
use Util;  use Codon; use BeginPerlBioinfo; use FASTA; use Align;   

 
############################################################
# Date:110303Tue        Author: Hong Qin
# Usage: $int_value = is_matched_codon_and_aa( $AA, $codon );
# Description: return 0 if umatched, 1 is matched
# Call: BeginPerlBioinfo::codon2aa()
# tested in test_aa.1.pl
# Used in Codon::format_cds_by_aa()

sub is_matched_codon_and_aa {
 use strict; use warnings; my $debug = 1; 
 my ( $AA, $codon ) = @_;

 my $translated_AA = codon2aa( $codon );
 if ( $AA eq $translated_AA  ) { return 1; 
 } else {  return 0; }

}

 
############################################################
# Date:031003Mon        Author: Hong Qin
# Usage: %synonymous_codons = get_synonymous_codons();
# Description: return synonymous codons keyed by AA in single letter
# Call: Codon::codon2aa()
# Call: Codon::getStandardCodons(\@complete_codon_set)
# Tested in ?
# Used in cu00 = codon_usage.0.0.pl
sub get_synonymous_codons {
 use strict; use warnings; my $debug = 0; use Codon;
 my @codons = ();
 getStandardCodons( \@codons );
 my %synonymous_codons = ( );

 if ($debug) { print "(AA)@codons\n"; }

 foreach my $codon (@codons) {
   my $aa = codon2aa( $codon );
   $synonymous_codons{ $aa } .= $codon . ' ';
 }

 if ($debug) { showHashTable( \%synonymous_codons ); }

 foreach my $aa ( keys %synonymous_codons ) {
  $synonymous_codons{ $aa } =~ s/\s+$//o ; 
 }

 if ($debug) { showHashTable( \%synonymous_codons ); }

 return %synonymous_codons ;
}



############################################################
# Date:031003Mon	Author: Hong Qin
# Usage: @aa1 = get_20_aa_letters();
# Description: return the 20 amino acid in single letter format
# Tested in ?
# Bug found on May 1, 2007, a 4-year-old bug
# Used in cu00 = codon_usage.0.0.pl
# 	aau00 = aminoacid_usage.00.pl  
sub get_20_aa_letters {
 use strict; use warnings; my $debug = 0;
 my $aa_line = "a c d e f g h i k l m n p q r s t v w y";

 $aa_line = uc $aa_line;
 my @aa1 = split ( /\s+/, $aa_line );    #change 050107
 if ($debug) { print "(AA::get_aa)[@aa1]\n" ; } 

 return @aa1;
}


##############################################################
1;

