############################################################
# subroutines for parsing FASTA files
# Hong Qin
# To use this module, put following lines
#  use lib '/shar/lib/perl/';     use FASTA; 
#
############################################################

BEGIN { unshift(@INC,"/home/hqin/lib/perl/");   }        
use Util;

my $_yn00_ctl= "
      seqfile = YNINPUT 	* sequence data file name
      outfile = YNOUTPUT        * main result file
      verbose = 0  * 1: detailed output (list sequences), 0: concise output

        icode = 0  * 0:universal code; 1:mammalian mt; 2-10:see below

    weighting = 0  * weighting pathways between codons (0/1)?
   commonf3x4 = 0  * use one set of codon freqs for all pairs (0/1)? 
*       ndata = 1

* Genetic codes: 0:universal, 1:mammalian mt., 2:yeast mt., 3:mold mt.,
* 4: invertebrate mt., 5: ciliate nuclear, 6: echinoderm mt., 
* 7: euplotid mt., 8: alternative yeast nu. 9: ascidian mt., 
* 10: blepharisma nu.
* These codes correspond to transl_table 1 to 11 of GENEBANK.

";


############################################################
# Date:	11103Tue	Author:Hong Qin
# Usage: $flag = pairwise_dNdS_by_yn00( \@DNAs_in, \@ids_in, \%dN_out, \%dS_out, \%omega_out, $tmp_yn00_out_flag  );
# Description: 	call yn00, return results in %dS_out, %dN_out
#  		$tmp_yn00_out_flag=1 output to /tmp/yn00/
# Calls ?
# Tested in ?
# Used in calculate_dNdS_of_CDS_by_yn00.00.pl

sub  pairwise_dNdS_by_yn00 {
 use strict; use warnings; my $debug = 0;
 my ( $r_dna, $r_ids, $rh_dN, $rh_dS, $rh_omega, $tmp_yn00_out_flag ) = @_;
 my @DNAs_in = @$r_dna;
 my @ids_in  = @$r_ids;
# my %dS      = %$rh_dS; # this does work as reference passing
# my %dN	     = %$rh_dN;
 if ( !(defined $tmp_yn00_out_flag ) ) { $tmp_yn00_out_flag = 0; } 

 my $time_stamp   =  get_short_time_stamp_US();    
 my $tmp_nuc_fl   = "/tmp/_$time_stamp.nuc";
 my $tmp_yn00_ctl = "/tmp/yn00.$time_stamp.ctl";
 my $tmp_yn00_out = "/tmp/_yn00.$time_stamp.out";

 my $num_of_dna   = $#DNAs_in + 1;
 my $seq_len      = length( $DNAs_in[0] );

 #generate *.nuc format for yn00
 my @nuc_lines = ();
 push (@nuc_lines, "  $num_of_dna $seq_len\n" );
 for (my $i=0; $i<= $#DNAs_in; $i++) {
   push (@nuc_lines, "$ids_in[$i]");
   my @wrapped_lines = return_wraped_lines( $DNAs_in[$i], 60 );  
   push (@nuc_lines, @wrapped_lines);
 }
 my $flag = array_2_file(\$tmp_nuc_fl, \@nuc_lines, \"\n");  
 if ($debug) {
    print "FASTA::pairwise_dNdS_by_yn00()\@nuc_lines=\n";
    print "\t@nuc_lines\n"; 
 }

 #generate yn00.ctl
 my $yn_ctl_line =  $_yn00_ctl;
 $yn_ctl_line    =~ s/YNINPUT/$tmp_nuc_fl/;
 $yn_ctl_line    =~ s/YNOUTPUT/$tmp_yn00_out/;
 my @yn_ctl_lines = ();
 push ( @yn_ctl_lines, $yn_ctl_line );
 $flag = array_2_file(\$tmp_yn00_ctl, \@yn_ctl_lines, \"\n");

 #call yn00
 system( "yn00 $tmp_yn00_ctl " );
 
 #parse results to %dS and %dN from $tmp_yn00_out
 open  ( _IN_pairwise_dNdS_by_yn00, "<$tmp_yn00_out");
 my @yn_lines = <_IN_pairwise_dNdS_by_yn00>;
 close ( _IN_pairwise_dNdS_by_yn00 );

 if ($debug) {  print "\@yn_lines=@yn_lines\n"; }

 # now, pop out the interesting lines

 ### parsing based on OLD formate 
  # my $offset = ( $num_of_dna * ( $num_of_dna - 1) ) / 2 + 2 ; 
  # my @new_yn_lines = splice ( @yn_lines, - $offset ); 
  # my @head_lines = splice( @new_yn_lines, 0, 2 );
  # foreach my $line ( @new_yn_lines ) {
  # $line =~ s/^\s+//g;
  # $line =~ s/\s+$//g;
  # my @tokens = split ( /\s+/, $line  );
  # $tokens[0] = $ids_in[ $tokens[0] - 1 ];  ### 061207 remove
  # $tokens[1] = $ids_in[ $tokens[1] - 1 ];  ### 061207 remove
  # $rh_dN->{ $tokens[0] . ' '. $tokens[1] }    = $tokens[  7 ]; # get dN
  # $rh_dS->{ $tokens[0] . ' '. $tokens[1] }    = $tokens[ 10 ]; # get dS
  # $rh_omega->{ $tokens[0] . ' '. $tokens[1] } = $tokens[ 6 ]; # get dN
  # my $new_line = join ( ' ', @tokens );
  # push ( @out_lines, $new_line );
  #}

  my @out_lines = ();

 ### 061207 parsing based on more recent format
  my $long_line = join( '', @yn_lines );
  my @sections = split( /\([ABC]\)/, $long_line ); # split output to 4 sections
  my @yn00lines = split( /\n/, $sections[2] );

  my $dataline = $yn00lines[8];
  $dataline =~ s/^\s+//go;
  if ($debug) {
    print "\$dataline=[$dataline]\n";
  }
  my @tokens = split ( /\s+/, $dataline  );
  $tokens[0] = $ids_in[ $tokens[0] - 1 ];  ### yn00 use sequential numbers  1  
  $tokens[1] = $ids_in[ $tokens[1] - 1 ];  ###                          and 2
  $rh_dN->{ $tokens[0] . ' '. $tokens[1] }    = $tokens[  7 ]; # get dN
  $rh_dS->{ $tokens[0] . ' '. $tokens[1] }    = $tokens[ 10 ]; # get dS
  $rh_omega->{ $tokens[0] . ' '. $tokens[1] } = $tokens[ 6 ]; # get dN
  my $new_line = join ( ' ', @tokens );
  push ( @out_lines, $new_line );


 if ( $tmp_yn00_out_flag > 0 ) {
  my $out = "/tmp/yn00/$ids_in[0]";
  # unshift ( @out_lines, @head_lines); ## 061207 removed
  $flag = array_2_file(\$out, \@out_lines, \"\n");  # store in /tmp/yn00/
 }

 if ($debug) {  
   # print "\@head_lines=@head_lines\n"; #061207 removed
   # print "\@new_yn_lines=@new_yn_lines\n"; 
   print "\@out_lines=@out_lines\n"; 
 }

 if ($debug == 0) {  
 system("rm $tmp_nuc_fl");
 system("rm $tmp_yn00_ctl");
 system("rm $tmp_yn00_out");
 }

 return 0;
}






############################################################
# Date:Nov 7, 2003	Author:Hong Qin
# Usage:  my @wrapped_lines = return_wraped_lines( $line, $length_per_line );
# Description: wrapped lines without lines breaks
# Calls ?
# Tested in ?
# Used in  wrap_fasta_sequences.00.l   

sub return_wraped_lines   {
 my ( $line, $length_per_line ) = @_;           my $debug=0;
 my $pos=0;
 my @wrapped_lines = ();
 
 chomp $line;
 while ( $pos < length($line) ) {
   push ( @wrapped_lines, substr( $line, $pos, $length_per_line  ) );
   $pos += $length_per_line ;
 }
 
 if ($debug) {
  print "_return_wrapped_lines():: $#wrapped_lines \@wrapped_lines= [@wrapped_lines]\n";
 }
 
 return @wrapped_lines;
}


############################################################
# Date: 041803Fri       Author:Hong Qin
# Usage:  $flag = adjust_last_codons1 ($in_cds_fl, $stop_codon_flag, $choice_of_stop );
# Description:
#    $stop_codon_flag = 1, set end codon to $choice_of_stop (default 'TAA')
#    $stop_codon_flag = 0, rm ending stop codon if seqs contains.
#    $choice_of_stop is optional
# Note: only works on paddled FASTA seqs (seq must in one line)
# Calls: Codon::  $Answer = EndIsStopCodon($dna);   
# 	 Util:: my $short_time_stamp = get_short_time_stamp_US();   
#	 Util:: $flag = array_2_file(\$filename, \@lines, \$delim);
# Tested on test/codon/stop.pl
# Used in cpcdsf21

sub adjust_last_codons1 {
 use strict; use warnings; my $debug = 0;
 my ( $in_cds_fl, $stop_codon_flag, $choice_of_stop ) = @_;
 if ( !( defined $choice_of_stop )) {  $choice_of_stop = 'TAA' ; } 

 if ($debug) {
  print "(FASTA:adjust_last_codons1) $in_cds_fl, $stop_codon_flag, $choice_of_stop \n";
 }

 my $short_time_stamp = get_short_time_stamp_US();
 my $tmp = "/tmp/_tmp.adjust_last_codons1.$short_time_stamp";

 open (Inadjust_last_codons1, "<$in_cds_fl");
 my @lines=<Inadjust_last_codons1>;
 close (Inadjust_last_codons1);

 if ( $stop_codon_flag ) {
   # attach stop codons
   foreach my $line ( @lines ) {
     chomp $line;
     if ( $line !~ /^>/ ) {
       if ( EndIsStopCodon($line) eq 'NO' ) {
  	  $line .= $choice_of_stop ;
       }
     }
   }
 } else {
   # rm stop codons
   foreach my $line ( @lines ) {
     chomp $line;
     if ( $line !~ /^>/ ) {
       if ( EndIsStopCodon($line) eq 'YES' ) {
	  $line =~ s/[\s\t\n]+//g;  # this will change the original format
          $line = substr($line, 0, (length($line)-3) ); 
       }
     }
   }   
 }

 my $flag = array_2_file(\$tmp, \@lines, \"\n" );    

 # system( " mv $in_cds_fl /tmp/$in_cds_fl.adjust_last_codons1 ");
 system( " cp $tmp $in_cds_fl ");
 system( " rm $tmp " );

 return 1;
}

############################################################
# Date: 030403Mon       Author:Hong Qin
# Usage:  $Nc = get_Nc_from_chips( \$seq );
# Description:
#	calculate Nc by calling chips (EMBOSS program)
# Calls:  chips
# Tested on test/codon/ data
# Used in enc.00.pl

sub get_Nc_from_chips {
 use strict; use warnings; my $debug = 0;
 my ( $r_seq ) = @_;
 my $Nc = 0;
 my ($prefix, @tokens) = ();
 my $header= ">temp seq by FASTA::get_Nc_from_chips\n";
 my $tmpfasta = "/tmp/_get_Nc_from_chips.fasta";
 my $tmpout = "/tmp/_Nc.chips";

 open (_get_Nc_from_chips_OUT, ">$tmpfasta"); 
 print _get_Nc_from_chips_OUT "$header$$r_seq\n"; 
 close (_get_Nc_from_chips_OUT);

 system ( "chips $tmpfasta $tmpout" );

 open (_get_Nc_from_chips_IN, "<$tmpout"); 
 my @lines = <_get_Nc_from_chips_IN>; 
 close (_get_Nc_from_chips_IN);

 my ($Nc_line) = grep ( /=/, @lines);
 chomp $Nc_line; 
 if ($debug) { print "(FASTA::get_Nc_from_chips)\$Nc_line:[$Nc_line]\n"; }

 ($prefix, $Nc, @tokens ) = split ( /\s*=\s*/, $Nc_line);

 if ($debug) { print "(FASTA::get_Nc_from_chips)\$Nc=[$Nc]\n"; } 

 return $Nc;
}


 
############################################################
# Date: 030403Mon       Author:Hong Qin
# Usage:  @uniq_tokens = extract_tokens_frm_a_fasta_header( \$header, \@uniq_token_pos );     
# Description:
#       return the  uniq tokens in \$header, indices defined by \@uniq_token_pos 
#	$header should be split in the same way
# Calls:  @tokens = get_tokens_in_a_fasta_header($header);
# Tested in ? 
# Used in cpcdsf1

sub extract_tokens_frm_a_fasta_header {
  use strict; use warnings; my $debug = 1;
  my ( $r_header, $r_pos ) = @_;
  my ( @extracted_tokens ) = ();

  my @tokens = get_tokens_in_a_fasta_header ( $$r_header );
  
  foreach my $i ( @$r_pos ) {
    push ( @extracted_tokens, $tokens[$i] );
  } 
  return @extracted_tokens;
}

############################################################  
# 030303Mon  Hong Qin
# Usage:  my @tokens = get_tokens_in_a_fasta_header ( $header );  
sub get_tokens_in_a_fasta_header {
 my ( $header ) = @_;
 $header =~ s/^>//go;   # 040803 change
 $header =~ s/^\s+//o;   # 122107 change
 my @tokens = split ( /[|:|\||\)\[\]|\(|\,|\;|\s|\/]+/, $header);  
 return @tokens;
}


############################################################
# Date:	030303Mon 	Author:Hong Qin
# Usage:  $flag = auto_detect_uniq_tokens_in_fasta_headers ($in_fl, $out_ctl_fl);      
# Usage:  $flag = auto_detect_uniq_tokens_in_fasta_headers2($in_fl, \@uniq_positions);      
# Description:
#	auto detect uniq tokens in fasta headers
#	store output in $out_ctl_fl
#	success is 0, failure 1
# 032703 sort the pos then output
# Calls Util:: @nonredunt_elements = get_nonredundant_elements ( \@elements );  
#	 my @tokens = get_tokens_in_a_fasta_header( $header );     
#	Util:: my $flag = array_2_filehandle_with_return(\$out, \@uniq_pos, \"\t");      
# Tested in fasta.pl
# Used in ?

sub auto_detect_uniq_tokens_in_fasta_headers2 {
  use strict; use warnings; my $debug = 1;
  my ($in, $r_pos) = @_;
  my $time_stamp = get_short_time_stamp_US();     
  my $out_ctl_fl = "/tmp/_fasta_header.$time_stamp.ctl";

  my $flag =  auto_detect_uniq_tokens_in_fasta_headers ($in, $out_ctl_fl); 

  unless( open (_auto_CTL, "<$out_ctl_fl") ) {
   print "Cannot generate controls to handle to FASTA headers. Bye.\n"; exit;
 }
 
 my @lines = <_auto_CTL>; close (_auto_CTL);

 if ($debug) { print "\nCTL: @lines"; }
 @lines = grep ( !/^\s*#/, @lines ); # rm possible comments
 @lines = grep ( !/^\s*>/, @lines ); # rm possible headers

 foreach my $line ( @lines ) {
   my @elements = split ( /[\s\t]+/, $line );
   foreach my $el (@elements) {
     if ( $el =~ /\d+/) {
       push ( @$r_pos, $el );
     }
   }
 }
 if ($debug) { print "\nThe uniq token pos are:[@$r_pos]\n";  }

 return 0;
}

sub auto_detect_uniq_tokens_in_fasta_headers {
  use strict; use warnings; my $debug = 0;
  my ($in, $out) = @_;
  open (IN, "<$in"); my @lines = <IN>; close (IN);
  my @headers = grep (  /^>/, @lines );
  my (%token_pos, %token_string, @uniq_pos) = ();

  foreach my $header ( @headers ) {
#    $header =~ s/^>//g;   #040803 change
    my @tokens = get_tokens_in_a_fasta_header( $header );
    if ($debug) { print "[@tokens]\n"; }
    foreach my $i ( 0..$#tokens ) {
      $token_string{$i} .= $tokens[$i]."\t";
    }
  }

  if ($debug>1) { showHashTable(\%token_string); print "\n"; }

  foreach my $key ( keys %token_string ) {
    if ($debug) { print "\$key is $key\n" }
    my @elements = split ( "\t", $token_string{$key});
    my @uniq_elements = get_nonredundant_elements ( \@elements );
    if ( $#elements == $#uniq_elements ) {
      push ( @uniq_pos, $key );
    }
  }

  @uniq_pos = sort @uniq_pos; # 032703

  open (OUT, ">$out");
  my @tokens = get_tokens_in_a_fasta_header ( $headers[0] );
  unshift ( @tokens, '>');    
  my $flag = array_2_filehandle_with_return( *OUT, \@tokens, \"\t");
     $flag = array_2_filehandle_with_return( *OUT, \@uniq_pos, \"\t");   
  close (OUT);
  return 0;
}

############################################################
# Date:042403Thu        Author:Hong Qin
# Usage: $flag = get_LcMod3_records_in_paddled_fasta_file1( $tmp_fasta_fl, $out_fasta_fl, $Lc_mod3 ) ;  
# Description:  
#	$Lc_mod3=0,1,2 
#       return 1 is success, 0 otherwise
# Tested in fasta.pl
# Used in pick_seqs_by_LcMod3.00.pl  
sub get_LcMod3_records_in_paddled_fasta_file1 {
 use strict; use warnings; my $debug = 1;
 my($infl, $outfl, $Lc_mod3) = @_;

 open (INget_LcMod3_records_in_paddled_fasta_file1, "<$infl");
 my @lines = <INget_LcMod3_records_in_paddled_fasta_file1>;
 close (INget_LcMod3_records_in_paddled_fasta_file1);
 
 my ( $head, $seq ) = ( );
 open ( OUTget_LcMod3_records_in_paddled_fasta_file1, ">$outfl");
 foreach my $i ( 0..$#lines ) {
   if ( $lines[$i] =~ /^>/ ) {
      $head =  $lines[$i] ;
   } elsif ( $head ne '' ) {
      my $seq =  $lines[$i] ;
         $seq =~ s/[\s\t\n]+//go;
      my $len = length( $seq );
      if (  ($len%3) == $Lc_mod3 ) {
        print OUTget_LcMod3_records_in_paddled_fasta_file1  "$head$lines[$i]";
      }
      $head = '';  # reset buffer
   }
 } #foreach
 
 close(OUTget_LcMod3_records_in_paddled_fasta_file1);
 return 1;
}



############################################################
# Date:042103Mon        Author:Hong Qin
# Usage: $flag = get_ATG_records_in_paddled_fasta_file1($infl, $outfl, $Lc_check_flag) ;
# Description: Take /^\s*ATG/ records only
#	optioal $Lc_check_flag=1 will filter out seqs with abnormal lengths
#       return 1 is success, 0 otherwise
# Tested in fasta.pl
# Used in ?

sub get_ATG_records_in_paddled_fasta_file1  {
 use strict; use warnings; my $debug = 1;
 my($infl, $outfl, $Lc_chekc_flag) = @_;
 if ( !(defined  $Lc_chekc_flag) ) { $Lc_chekc_flag = 0; }

 # print "$infl, $outfl, $Lc_chekc_flag \n";

 open (INget_ATG_records_in_paddled_fasta_file1, "<$infl");
 my @lines = <INget_ATG_records_in_paddled_fasta_file1>; 
 close (INget_ATG_records_in_paddled_fasta_file1);

 my ( $head, $seq ) = ( );
 open ( OUTget_ATG_records_in_paddled_fasta_file1, ">$outfl");
 foreach my $i ( 0..$#lines ) {
   if ( $lines[$i] =~ /^>/ ) {
      $head =  $lines[$i] ;
   }
 
   if ( $lines[$i] =~ /^\s*ATG/i ) {
      my $seq =  $lines[$i] ;
         $seq =~ s/[\s\t\n]+//go;
      my $len = length( $seq );
      if ( ($Lc_chekc_flag) and ( ($len%3) == 0 )) {
        print OUTget_ATG_records_in_paddled_fasta_file1 "$head$lines[$i]";
      } elsif (! $Lc_chekc_flag) {
        print OUTget_ATG_records_in_paddled_fasta_file1 "$head$lines[$i]";
      }
      $head = '';  # reset buffer
   }
 } #foreach
 
 close(OUTget_ATG_records_in_paddled_fasta_file1);

 return 1;
}


############################################################
# Date:030303Mon	Author:Hong Qin
# Usage: $flag = paddle_fasta_file1($infl, $outfl)
# Description: paddle sequences into one line
# 	return 1 is success, 0 otherwise
# Tested in fasta.pl
# Used in ?

sub paddle_fasta_file1 {
 use strict; use warnings; my $debug = 0;
 my($infl, $outfl) = @_;
 my $one_record = '';

 open ( IN_paddle_fasta_file1, "<$infl");
 my @lines = <IN_paddle_fasta_file1>;
 close ( IN_paddle_fasta_file1 );

 my @newlines = grep !/^\s*#/, @lines;  # rm the comments
 @newlines = grep ! /^\s*$/, @newlines;   # rm blank lines
 @lines = @newlines;
 @newlines = (); 	# release memory
 push (@lines, ">END"); # the end for parsing

 if ($debug) {
  foreach my $i ( 0.. $#lines ) { print "$i \t $lines[$i]"; }
  print "\n\n";
 }

 open ( OUT_paddle_fasta_file1 , ">$outfl");
 foreach my $i ( 0..$#lines ) {
   if ( ( $lines[$i] =~ /^>/) and ($one_record ne ''))  {
#     if ($debug) { print "first loop[$i]:$lines[$i]";  };  
     print OUT_paddle_fasta_file1 "$one_record\n";
   } 

#   if ($debug) { print "$i $lines[$i]";  };

   if ( $lines[$i] =~ /^>/ ) {
       $one_record = $lines[$i] ;
      if ($debug) { print "$i $lines[$i]";  };
   } else {
#       if ($debug) { print "$i $lines[$i]";  };
       $lines[$i] =~ s/\s+//g;
       # $lines[$i] =  uc $lines[$i] ;  ### change 022108
       $one_record .= $lines[$i];
   }

 } #foreach

 close(OUT_paddle_fasta_file1);

 return 1;
}


##############################################################
1;

