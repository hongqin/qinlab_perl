############################################################
# subroutines for editing alignment, blast out
# Hong Qin
# To use this module, put following lines
#  use lib '/shar/lib/perl/';     use Align; 
#
############################################################

BEGIN { unshift(@INC,"/home/hqin/shar/lib/perl/"); }       

use BeginPerlBioinfo; use AA; use Codon;


############################################################
# Date:	Nov 11, 03 Author: Hong Qin
# Usage: $reformated_cds_line = format_cds_by_aa($cds_in, $aa_in, $gap_symbol);
# Description: format a cds-line by an aa-line
#	$gap_symbol is optional, default is '-'
# Calls BeginPerlBioinfo::codon2aa()
# Bugs: 111203 fragmented output ?
# Tested in ?
# Used in align_cds_by_protein_clustalw.00.pl  

sub format_cds_by_aa {
  use strict; use warnings; my $debug = 0;
  my ( $cds_in, $aa_in, $gap_symbol ) = @_;
  my $reformatted_cds = '';
  my ( @triplets, @AAs ) = ();
  if ( ! (defined $gap_symbol) ) { $gap_symbol= '-'; }

  chomp $cds_in;
  chomp $aa_in;
  $cds_in =~ s/\s+//g;
  $aa_in  =~ s/\s+//g;

  my $cds_len = length( $cds_in );  
  for( my $i=0; $i<$cds_len; $i +=3 ) {
     push ( @triplets, substr( $cds_in, $i, 3 ) );
  }
  @AAs = split ( //, $aa_in );   

  if ($debug) {
   print "\nAlign::format_cds_by_aa:\@triplets=[@triplets]\n";
   print "\nAlign::format_cds_by_aa:\@AAs=[@AAs]\n"; 
  }

  my ( $i, $j ) = ( 0, 0 );
  while ( $i <= $#AAs  ) {
    my $AA = $AAs[$i];
    if ( $AA ne $gap_symbol )	 {
       my $current_triplet = $triplets[ $j ];
       $reformatted_cds   .= $current_triplet ;
       if ( $i and $j and ( is_matched_codon_and_aa( $AA, $current_triplet ) == 0 ) ) {
           print "Align:: $i-th AA($AA) and $j-th triplet($current_triplet) ";
       }
       $j++;
    } else {
      $reformatted_cds .= $gap_symbol . $gap_symbol . $gap_symbol ; # changed 111203
    }
    if ($debug) { $reformatted_cds .= ' '; }
    $i ++;
  }

  if ($debug) { print "\nAlign::format_cds_by_aa:\$reformatted_cds=$reformatted_cds\n\n"; }
  return $reformatted_cds;
}


############################################################
#Usage: ( $current_record_in_one_line, $returned_file_position)
#       = get_fasta_network_config_in_line3($infile1, $file_position);
# 
# Tested in /home/hqin2/data/Sce/network_evo_analysis_June02/testingdata/test_align_get_record3.pl
# Used in count_edges_amnong_categories_inFasta_network_configs.pl
sub  get_fasta_network_config_in_line3{
  use strict; use warnings;  my $debug = 0;
  my $infile = $_[0];  my $position = $_[1];
  my $current_content = "";    my ( $line, @lines, $offset1, $offset2 ) = ();

  open ( _IN_get_fasta_network_config_in_line3, "<$infile");
  seek ( _IN_get_fasta_network_config_in_line3, $position, 0 );

  $current_content = <_IN_get_fasta_network_config_in_line3> ;
  if ($debug) { print "(Align.get...)$current_content"; }
  $line = <_IN_get_fasta_network_config_in_line3> ;
  if ($debug) { print "(Align.get...)$line";}
  $offset1 = tell(_IN_get_fasta_network_config_in_line3);
  while  ( !( $line =~ m/^>/ ) )  {
     $offset2 = tell(_IN_get_fasta_network_config_in_line3);
     $current_content .= $line;  # This should include the FASTA header
     $line = <_IN_get_fasta_network_config_in_line3> ;   
     if ( ! defined($line) ) {
        return (  $current_content, -1);
     }
  } # while_loop
  close ( _IN_get_fasta_network_config_in_line2 );
  return ( $current_content, $offset2 );
}






#____________________________tested_ones____________________________
 
############################################################
#Usage: ( $position_of_next_record, $current_record_in_one_line)
#       = get_fasta_network_config_in_line2($infile1, $ith_record);
# Note: in-memory approach
# Tested in /home/hqin2/data/Sce/network_evo_analysis_June02/testingdata/test_align_get_record2.pl   
# Used in count_edges_amnong_categories_inFasta_network_configs.pl
sub  get_fasta_network_config_in_line2{  
  use strict; use warnings;  my $debug = 1;
  my $infile = $_[0]; my $ith_record = $_[1];
  my $current_content = "";    my $i = 0;   my ( $line, @lines ) = ();
 
  open ( _IN_get_fasta_network_config_in_line2, "<$infile"); 
  @lines = <_IN_get_fasta_network_config_in_line2>;
  close ( _IN_get_fasta_network_config_in_line2 );

  while (( $i <= $ith_record ) && ( @lines > 0 ) )  {
     $line = shift @lines ;
     if ( $line =~ m/^>/ ) {    $i ++;     }
     if ( $i == $ith_record ) {
          $current_content .= $line;  # This should include the FASTA header
     }
  } # while_loop

  if ( $i == $ith_record ) { 
	return ( -1, $current_content); 
  } else {  return ($i, $current_content); }
}

############################################################
#Usage: ( $position_of_next_record, $current_record_in_one_line) 
#	= get_fasta_network_config_in_line($infile1, $ith_record);     
# Note: line-by-line approach	
# Tested in /home/hqin2/data/Sce/network_evo_analysis_June02/testingdata/test_align_get_record.pl
# Used in count_edges_amnong_categories_inFasta_network_configs.pl

sub  get_fasta_network_config_in_line{
  use strict; use warnings;  my $debug = 1;  
  my $infile = $_[0]; my $ith_record = $_[1];  
  my $current_content = "";    my $i = 0;   my ( $line ) = ();

  open ( _IN_get_fasta_network_config_in_line, "<$infile");
  while ( $i <= $ith_record )  {
     $line = <_IN_get_fasta_network_config_in_line> ;
     if ( defined $line ) { 
       if ( $line =~ m/^>/ ) { 
          $i ++; 
       }
       if ( $i == $ith_record ) {
          $current_content .= $line;  # This should include the FASTA header
       }
     } else {
       #we have reached the end of the file
       return (-1, $current_content);
     }
  } # while_loop
  close ( _IN_get_fasta_network_config_in_line );
  return ($i, $current_content); 
}

#----------------------------------------------------------------------------


############################################################  
# Usage:  %nucPairCount =count16NucPairs(\@alignedPair);	
sub count16NucPairs {
   use strict;
   my @aln = @{$_[0]};   my $buffer =""; my ($key, $value);
   my $debug = 0;
   my %nucPairCount= (
	'TT' => 0 ,
	'CC' => 0 ,
	'AA' => 0 ,
	'GG' => 0 ,

	'TC' => 0 ,
	'CT' => 0 ,
	'AG' => 0 ,
	'GA' => 0 ,

	'TA' => 0 ,
	'AT' => 0 ,
	'AC' => 0 ,
	'CA' => 0 ,
	'TG' => 0 ,
	'GT' => 0 ,
	'CG' => 0 ,
	'GC' => 0   );

  die "()Uequal length." if ( length($aln[0])!=length($aln[1]) );  

  for (my $i=0; $i<length($aln[0]); $i++) {
    $buffer .= substr($aln[0],$i,1).substr($aln[1],$i,1).'-';  #This should work for gapped alignment
  }

  $buffer = uc $buffer;  #ensure uppercase characters
  if ($debug) {print "$buffer \n";}

  #count each key's occurence in the $buffer
  my @pairs = split (/[-]+/,$buffer);
  foreach my $pair(@pairs) {
    if ( length($pair)==2 ) { $nucPairCount{$pair}++; }
  }
  return %nucPairCount;
}




############################################################
#Usage: @aln_no_gap = removeGaps_in_alignedPair(\@gaped_align);
#  The symbol for gap is "-"
#
sub removeGaps_in_alignedPair {
  use strict;
  my @aln = @{$_[0]};  my @newaln = ("",""); my $i;

  die "(removeGaps_in_alignedPair)Unequal length." if ( length($aln[0])!=length($aln[1]) );
  for ($i=0; $i<length($aln[0]); $i++) {
    if ((substr($aln[0],$i,1) ne '-') && (substr($aln[1],$i,1) ne '-')) {
      $newaln[0] .= substr($aln[0],$i,1) ;
      $newaln[1] .= substr($aln[1],$i,1) ;
    }
  }
  return @newaln;
}


##############################################################
1;

