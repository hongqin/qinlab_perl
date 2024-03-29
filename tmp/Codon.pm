############################################################
# subroutines for codon anlysis
# Hong Qin
# 
############################################################
use lib '/shar/lib/perl';     
use Util; use BeginPerlBioinfo;
BEGIN { unshift(@INC,"/home/hqin/shar/lib/perl/");   }


 
############################################################
# Date:040703Mon        Author: Hong Qin
# Usage: my @triplets = line2triplets( \$line );
# Description:
#       return triplets from $line
# Calls:
#  $string_of_delimited_triplets = seq2delimited_triplets($seq);
# Tested in ?
# Used in ssg00

sub line2triplets {
 use strict; use warnings;  my $debug = 0;
 my ( $r_seq ) = @_;
 
# chomp $$r_seq;
 my @triplets = split( /\s+/, seq2delimited_triplets($$r_seq) );

 if ($debug) {
   print "(Codon::line2triplets)[@triplets]\n";
 }
 
 return @triplets;
}


############################################################
# Date:030403Tue        Author: Hong Qin
# Usage: my %triplet_pos = get_triplet_positions_in_a_string( \$line );       
# Description:
#	return the indices of triplet in $line, first one is zero
# Calls:
#  $string_of_delimited_triplets = seq2delimited_triplets($seq);      
# Tested on test/codon/g1
# Used in cpcdsf1

sub get_triplet_positions_in_a_string {
 use strict; use warnings;  my $debug = 1;
 my ( $r_seq ) = @_;
 my ( %triplet_pos ) = ();

# chomp $$r_seq;
 my @triplets = split( /\s+/, seq2delimited_triplets($$r_seq) );

 foreach my $i ( 0..$#triplets ) {
   if (exists $triplet_pos{ $triplets[$i] } ) {
      $triplet_pos{  $triplets[$i]  } .= ' '.$i;
   } else {
      $triplet_pos{  $triplets[$i]  } = $i;
   }
 } 
 return %triplet_pos;
}



############################################################
# Date:030303Mon	Author: Hong Qin
# Usage: $string_of_delimited_triplets = seq2delimited_triplets($seq);
# Description:
#   convert a string of characters into ' ' delimited triplets
#   Note substr give no warnings for non-triplet ends
# Calls ?
# Tested in fasta.pl
# Used in ?

sub seq2delimited_triplets {
 use strict; use warnings;  my $debug = 0;
 my ( $seq ) = @_;
 my $result = '';
 my $len = length($seq);

 if ($debug) { print "(Codon::seq2triplets)input:$seq\n"; } 
 
 for ( my $i=0; $i<$len; $i += 3) {
   $result .= substr( $seq, $i, 3) . ' ';
 }

 if ($debug) { print "(Codon::seq2triplets)return:$result\n"; } 

 return $result;
}



############################################################
# Usage: showCodonTableInTCAG2(\%codons_hash1, \%codons_hash2);
#   return an array of 19 lines, containing the 4x4 codon table
# Depends on  BeginPerlBioinfo:codon2aa;
sub showCodonTableInTCAG2 {
  use strict; use warnings;
  my ( %hashTable1 ) = %{$_[0]};
  my ( %hashTable2 ) = %{$_[1]};
  my ( $key, $value, $i,$firstOne, $secondOne, $thirdOne, $query_codon);
  my ( @lines );
  my ( @nucleotides ) = ( 'T', 'C' , 'A', 'G' );
 
  foreach $i (0..19) { $lines[$i] = '';  };

  foreach $firstOne (0..3) {
    foreach $thirdOne (0..3) {
      foreach $secondOne (0..3) {
        $query_codon = $nucleotides[$firstOne].$nucleotides[$secondOne].$nucleotides[$thirdOne];
        $i = $firstOne * 5 + $thirdOne;
        $lines[$i] .= $query_codon."(".codon2aa($query_codon).")=>".$hashTable1{$query_codon};
	$lines[$i] .= " (".$hashTable2{$query_codon}.")";
        if ($secondOne != 3 ) { $lines[$i] .= "\t"; }
      }
    }
  }
  
  foreach $i (0..19) { $lines[$i] .= "\n";  };
  return @lines;
}





############################################################
# Usage: showCodonTableInTCAG(\%codons_hash);
#   return an array of 19 lines, containing the 4x4 codon table
# Depends on  BeginPerlBioinfo:codon2aa;
# 031003 add 'NA' for missing codon

sub showCodonTableInTCAG {
  use strict; use warnings;
  my %hashTable = %{$_[0]};
  my ( $key, $value, $i,$firstOne, $secondOne, $thirdOne, $query_codon);
  my ( @lines );
  my ( @nucleotides ) = ( 'T', 'C' , 'A', 'G' );  
  
  foreach $i (0..19) { $lines[$i] = '';  };

  foreach $firstOne (0..3) {
    foreach $thirdOne (0..3) {
      foreach $secondOne (0..3) {
	$query_codon = $nucleotides[$firstOne].$nucleotides[$secondOne].$nucleotides[$thirdOne];
        $i = $firstOne * 5 + $thirdOne; 
	if ( exists $hashTable{ $query_codon } ) {
	  $lines[$i] .= $query_codon."(".codon2aa($query_codon).")=>".$hashTable{$query_codon};
        } else { 
	  $lines[$i] .= $query_codon."(".codon2aa($query_codon).")=>NA"; #031003
      	}
        if ($secondOne != 3 ) { $lines[$i] .= "\t"; }
      }
    }
  }

  foreach $i (0..19) { $lines[$i] .= "\n";  };
  return @lines;
}

 
############################################################
# Usage: getStandardCodonsHashTable(\%codons_hash);
#   Return a hashtable, the keys are a complete set of genetics codons, in deoxynucleotide form
#   All values are set to zero.
# Depends on getStandardCodon() subroutine.

sub getStandardCodonsHashTable {
  use strict; use warnings;
  my @codons = ();
  getStandardCodons(\@codons);

  foreach my $codon (@codons) {
    $_[0]{$codon} =0;   # The input has got to be a hash table.
  }
}




 


############################################################     
# Usage: getStandardCodons(\@codons);
#   return a complete set of genetics codons, in deoxynucleotide form

sub getStandardCodons{
    my ( @genetic_codons) = (
    'TTT',    # Phenylalanine
    'TTC',    # Phenylalanine
    'TTA',    # Leucine
    'TTG',    # Leucine

    'TCT',    # Serine
    'TCC',    # Serine
    'TCA',    # Serine
    'TCG',    # Serine

    'TAT',    # Tyrosine
    'TAC',    # Tyrosine
    'TAA',    # Stop
    'TAG',    # Stop

    'TGT',    # Cysteine
    'TGC',    # Cysteine
    'TGA',    # Stop
    'TGG',    # Tryptophan

    'CTT',    # Leucine
    'CTC',    # Leucine
    'CTA',    # Leucine
    'CTG',    # Leucine

    'CCT',    # Proline
    'CCC',    # Proline
    'CCG',    # Proline
    'CCA',    # Proline

    'CAT',    # Histidine
    'CAC',    # Histidine
    'CAA',    # Glutamine
    'CAG',    # Glutamine

    'CGT',    # Arginine
    'CGC',    # Arginine
    'CGG',    # Arginine
    'CGA',    # Arginine

    'ATT',    # Isoleucine
    'ATC',    # Isoleucine
    'ATA',    # Isoleucine
    'ATG',    # Methionine

    'ACT',    # Threonine
    'ACC',    # Threonine
    'ACA',    # Threonine
    'ACG',    # Threonine

    'AAT',    # Asparagine
    'AAC',    # Asparagine
    'AAA',    # Lysine
    'AAG',    # Lysine

    'AGT',    # Serine
    'AGC',    # Serine
    'AGA',    # Arginine
    'AGG',    # Arginine

    'GTT',    # Valine
    'GTC',    # Valine
    'GTA',    # Valine
    'GTG',    # Valine

    'GCT',    # Alanine
    'GCC',    # Alanine
    'GCA',    # Alanine
    'GCG',    # Alanine

    'GAT',    # Aspartic Acid
    'GAC',    # Aspartic Acid
    'GAA',    # Glutamic Acid
    'GAG',    # Glutamic Acid

    'GGT',     # Glycine		
    'GGC',    # Glycine
    'GGA',    # Glycine
    'GGG',    # Glycine
   );
   push (@{$_[0]}, @genetic_codons);   
}

############################################################
# Usage: $Answer = EndIsStopCodon($dna);
# $Answer is either 'YES' or 'NO', but 'ERROR' when error occurs
# Only the regular stops codons are used!!!
# tested in t5.pl
#
sub EndIsStopCodon {
  use strict; use warnings;
  my ($debug) = 0 ;
  my ($dna )= $_[0];
  my (@STOP )= ("TAA","TAG","TGA");  

  $dna =~ s/[\s\t\n]+//g;	# rm blanks  041803 change

  my ($length) = length($dna);

  if ( ($length%3) != 0 ) {
    print "(EndIsStopCodon) Warning! The length of the DNA seq is $length\n" ;
    print "$dna\n";
    return "ERROR\n";
  }

  my $lastTriplet = uc  substr($dna, $length-3);

  if ($debug) {
    print ("(EndIsStopCodon) Length is $length\n")    ;
    print ("(EndIsStopCodon) LastTriplet is $lastTriplet\n")    ;
  }

  foreach my $codon(@STOP) {
    if ( $lastTriplet eq $codon ) { return "YES"  }
  }  

  return "NO";
}


############################################################
#Usage: %merged_codon_counts = mergeCounts(\%FirstCount, \%SecondCount);
# This should work on any hashtables, though I only test on codon counts.
#
sub mergeCounts {
  use strict; use warnings;    
  my $debug =0 ;
  my %FirstCount = %{$_[0]};
  my %SecondCount = %{$_[1]};
  my %total = ();
  my ( $i, $key ); 
  
  my $size1 = scalar keys(%FirstCount);
  my $size2 = scalar keys(%SecondCount);

  if ( $size1 != $size2 ) {
    print "(mergeCounts) Stop..First table size is $size1, Second table size is $size2.\n";      
    exit;
  }

  foreach $key (keys(%FirstCount)) {
     $total{$key}= $FirstCount{$key} + $SecondCount{$key}
  }

  if ($debug) {
    print "(mergeCounts)Begin..First Input.....\n";
    showHashTable2(\%FirstCount,0.1) ;  
    print "(mergeCounts).......Second Input.....\n";
    showHashTable2(\%SecondCount,0.1) ;  
  }

  if ($debug) {  
    print "(mergeCounts).......Sum of the two Inputs.....\n";
    showHashTable2(\%total,0.1) ;  
    print "(mergeCounts)......Ends\n";
  }
  return %total;  
}




############################################################
#Usage:  $four_fold_seq = dna2_4fold($nuc);   
#Requires BeginPerlBioinfo.pm 
sub dna2_4fold{
  use strict; use warnings;
  my ($dna) = @_;
  my $result ="";
  my $codon ="";
  my $debug =0;
 
  for (my $i=0; $i< (length($dna)-2); $i+=3) {
    $codon = substr($dna, $i, 3);
    if ( codon_is_nfold($codon) == 4) {
      $result .= substr($codon, 2, 1);
      if($debug) {
        print "$codon-->";
        print codon2aa($codon)."\t";
      }
    }
  }
  return $result;
}



############################################################
#Usage: %codon_counts = countEachOf64Codons($dna_seq_no_gap);
# Return a hash table that contains the frequecies of each codon 
# The input sequence is a continuous seqeuence, no space, no gap
# Tested in t4.pl
sub countEachOf64Codons {
    use strict;
    use warnings;
    my ($dna) = @_;
    my ($length, $i, $codon);
    my $debug =0;
    
    $dna = uc $dna;
    if ($debug) { print "(countEachOf64Codons) Seq: $dna ...\n "}

    $length = length($dna);
    if ( ($length%3) != 0 ) {
      print("(countEachOf64Codons) Stop! The length of the DNA seq is $length\n");
      exit;
    }  

    my (%genetic_code) = (
    'TTC' => 0,    # Phenylalanine
    'TTT' => 0,    # Phenylalanine
    'TTA' => 0,    # Leucine
    'TTG' => 0,    # Leucine
    'TCA' => 0,    # Serine
    'TCC' => 0,    # Serine
    'TCG' => 0,    # Serine
    'TCT' => 0,    # Serine
    'TAC' => 0,    # Tyrosine
    'TAT' => 0,    # Tyrosine
    'TAA' => 0,    # Stop
    'TAG' => 0,    # Stop
    'TGC' => 0,    # Cysteine
    'TGT' => 0,    # Cysteine
    'TGA' => 0,    # Stop
    'TGG' => 0,    # Tryptophan
    'CTA' => 0,    # Leucine
    'CTC' => 0,    # Leucine
    'CTG' => 0,    # Leucine
    'CTT' => 0,    # Leucine
    'CCA' => 0,    # Proline
    'CCC' => 0,    # Proline
    'CCG' => 0,    # Proline
    'CCT' => 0,    # Proline
    'CAC' => 0,    # Histidine
    'CAT' => 0,    # Histidine
    'CAA' => 0,    # Glutamine
    'CAG' => 0,    # Glutamine
    'CGA' => 0,    # Arginine
    'CGC' => 0,    # Arginine
    'CGG' => 0,    # Arginine
    'CGT' => 0,    # Arginine
    'ATA' => 0,    # Isoleucine
    'ATC' => 0,    # Isoleucine
    'ATT' => 0,    # Isoleucine
    'ATG' => 0,    # Methionine
    'ACA' => 0,    # Threonine
    'ACC' => 0,    # Threonine
    'ACG' => 0,    # Threonine
    'ACT' => 0,    # Threonine
    'AAC' => 0,    # Asparagine
    'AAT' => 0,    # Asparagine
    'AAA' => 0,    # Lysine
    'AAG' => 0,    # Lysine
    'AGC' => 0,    # Serine
    'AGT' => 0,    # Serine
    'AGA' => 0,    # Arginine
    'AGG' => 0,    # Arginine
    'GTA' => 0,    # Valine
    'GTC' => 0,    # Valine
    'GTG' => 0,    # Valine
    'GTT' => 0,    # Valine
    'GCA' => 0,    # Alanine
    'GCC' => 0,    # Alanine
    'GCG' => 0,    # Alanine
    'GCT' => 0,    # Alanine
    'GAC' => 0,    # Aspartic Acid
    'GAT' => 0,    # Aspartic Acid
    'GAA' => 0,    # Glutamic Acid
    'GAG' => 0,    # Glutamic Acid
    'GGA' => 0,    # Glycine
    'GGC' => 0,    # Glycine
    'GGG' => 0,    # Glycine
    'GGT' => 0,    # Glycine
    );

    for ($i=0; $i<$length; $i+=3) {
      $codon = substr($dna,$i,3);
      if ($debug) { print "(countEachOf64Codons) Processing $codon ...\n "}
      if(exists $genetic_code{$codon}) {
        $genetic_code{$codon} ++;
      }else{
        print "(countEachOf64Codons) Stop. Bad codon \"$codon\"!! in input DNA seq.\n";
        exit;
      }
    }
    return %genetic_code;
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



############################################################
#Usage $num_of_fold = codon_is_nfold($codon);
#Tested in test01.pl
sub codon_is_nfold {
     use strict;
     my($codon) = @_;
  
        if ( $codon =~ /GC./i)        { return 4 }    # Alanine
     elsif ( $codon =~ /TG[TC]/i)     { return 2 }    # Cysteine
     elsif ( $codon =~ /GA[TC]/i)     { return 2 }    # Aspartic Acid
     elsif ( $codon =~ /GA[AG]/i)     { return 2 }    # Glutamic Acid
     elsif ( $codon =~ /TT[TC]/i)     { return 2 }    # Phenylalanine
     elsif ( $codon =~ /GG./i)        { return 4 }    # Glycine
     elsif ( $codon =~ /CA[TC]/i)     { return 2 }    # Histidine
     elsif ( $codon =~ /AT[TCA]/i)    { return 2 }    # Isoleucine
     elsif ( $codon =~ /AA[AG]/i)     { return 2 }    # Lysine
     elsif ( $codon =~ /TT[AG]|CT./i) { return 4 }    # Leucine
     elsif ( $codon =~ /ATG/i)        { return 1 }    # Methionine
     elsif ( $codon =~ /AA[TC]/i)     { return 2 }    # Asparagine
     elsif ( $codon =~ /CC./i)        { return 4 }    # Proline
     elsif ( $codon =~ /CA[AG]/i)     { return 2 }    # Glutamine
     elsif ( $codon =~ /CG.|AG[AG]/i) { return 4 }    # Arginine
     elsif ( $codon =~ /TC.|AG[TC]/i) { return 4 }    # Serine
     elsif ( $codon =~ /AC./i)        { return 4 }    # Threonine
     elsif ( $codon =~ /GT./i)        { return 4 }    # Valine
     elsif ( $codon =~ /TGG/i)        { return 1 }    # Tryptophan
     elsif ( $codon =~ /TA[TC]/i)     { return 2 }    # Tyrosine
     elsif ( $codon =~ /TA[AG]|TGA/i) { return 0 }    # Stop
     else {
         print STDERR "(codon_is_nfold) Bad codon \"$codon\"!!\n";
         return -1 ;
     }
}

1;

