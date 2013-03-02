############################################################
# subroutines for Nucleotide Anlysis
# Hong Qin
# 
############################################################
use lib 'lib/perl';     
use Util; use BeginPerlBioinfo;
BEGIN { unshift(@INC,"/home/hqin/lib/perl/");   }

############################################################
# Date:	031504Mon	Author: Hong Qin
# Usage: $flag = countNucleotides_in_single_sequence($line,\%count_hash );
# Description:
# Calls: none
# Tested in ?
# Used in nucleotide_composition.00.pl 

sub countNucleotides_in_single_sequence {
 use strict; use warnings; my $debug = 1; 
 my ( $dna, $r_out_hash ) = @_;

 $r_out_hash->{'A'} = ( $dna =~ tr/Aa//);
 $r_out_hash->{'C'} = ( $dna =~ tr/Cc//);
 $r_out_hash->{'G'} = ( $dna =~ tr/Gg//);
 $r_out_hash->{'T'} = ( $dna =~ tr/Tt//);

 return 1;
}

############################################################
#Usage: $num_of_T = countT($dna_seq);
# The counting is case-insensitive

sub countT {
    use strict;
    my($dna) = @_;
    my($count) = 0;
    $count = ( $dna =~ tr/Tt//);
    return $count;
}

sub countC {
    use strict;
    my($dna) = @_;
    my($count) = 0;
    $count = ( $dna =~ tr/Cc//);
    return $count;
}

sub countA {
    use strict;
    my($dna) = @_;
    my($count) = 0;
    $count = ( $dna =~ tr/Aa//);
    return $count;
}

sub countG {
    use strict;
    my($dna) = @_;
    my($count) = 0;
    $count = ( $dna =~ tr/Gg//);
    return $count;
}



1;

