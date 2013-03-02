############################################################
# Date:030303Mon	Author:Hong Qin
# Usage: $flag = paddle_fasta_file1($infl, $outfl)
# Description: paddle sequences into one line
# 	return 1 is success, 0 otherwise
# Tested in fasta.pl
# Used in ?

########################################################
package FASTAshort; 

###
#Usage: paddle_fasta_file1($infl, $outfl);

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


#######################
# Usage  paddle_fasta_file2($infl, $outfl); #less memory

sub paddle_fasta_file2 { #try to use less memory
 use strict; use warnings; my $debug = 0;
 my($infl, $outfl) = @_;
 my $one_record = '';

 open ( IN_paddle_fasta_file1, "<$infl");
 open ( OUT_paddle_fasta_file1 , ">$outfl");
 
 my $i=0;
 while ( my $line = <IN_paddle_fasta_file1> ) {
   if ( ( $line !~ /^\s*#/ ) && ( $line !~ /^\s*$/ ) ) {
      if (  $line =~ /^>/ )  {
         if ($i > 0) {
             print OUT_paddle_fasta_file1 "\n";
         }
         print OUT_paddle_fasta_file1 "$line";
         $i++;
      } else {
      	 chomp $line;
      	 $line =~ s/s+//g;
      	 print OUT_paddle_fasta_file1 "$line";
      } 
   }

 } #foreach
 print OUT_paddle_fasta_file1 "\n";

 close ( OUT_paddle_fasta_file1);
 close ( IN_paddle_fasta_file1 );

 return 1;
}


########################################################
# Usage: my @paddled_lines = paddle_fasta_file_to_array ($infile);
# not tested yet; 
sub paddle_fasta_file_to_array {
 use strict; use warnings; my $debug = 1;
 my($infl) = @_;

 my $one_record = '';  #contain "$header\n$seq";
 my @results = ();

 open ( IN_paddle_fasta_file1, "<$infl");  
 my @lines = <IN_paddle_fasta_file1>;
 close ( IN_paddle_fasta_file1 );

 my @newlines = grep !/^\s*#/, @lines;  # rm the comments
 @newlines = grep ! /^\s*$/, @newlines;   # rm blank lines
 @lines = @newlines;
 @newlines = (); 	# release memory
 push (@lines, ">END"); # the end for parsing

 foreach my $i ( 0..$#lines ) {
   if ( ( $lines[$i] =~ /^>/) and ($one_record ne ''))  {
      push (@results, $one_record);
      $one_record = ''; #not necessay
   } 
   
   if ( $lines[$i] =~ /^>/ ) {
       $one_record = $lines[$i] ;
       if($debug) { print "buffer is [$one_record]\n"; }
   } else {
       $lines[$i] =~ s/\s+//g;  #remove \n
       $one_record .= $lines[$i];
   }
 } #foreach

 return @results;
}


########################################################
# Usage: my @paddled_lines = paddle_fasta_file_to_array2 ($infile);
# not tested yet; 
sub paddle_fasta_file_to_array2 {
 use strict; use warnings; my $debug = 0;
 my($infl) = @_;

 open ( IN_paddle_fasta_file1, "<$infl") || die "$infl does not  exist.\n";
 my @lines = <IN_paddle_fasta_file1>;
 close ( IN_paddle_fasta_file1 );

 my @newlines = grep !/^\s*#/, @lines;  # rm the comments
 @newlines = grep ! /^\s*$/, @newlines;   # rm blank lines
 @lines = @newlines;
 @newlines = (); 	# release memory

 #this is one way to read all the FASTA record
 #push (@lines, ">END"); ##here, we can articficall add a signal

 my @headers = ();
 my @seqs    = ();

 my $num_of_lines = scalar @lines; 
 my $buffer= '';

 #there are the key part of reading a FASTA file
 for( my $i = 0; $i<= ($num_of_lines -1 ); $i=$i+1 ) {
  my $line = $lines [$i];
  chomp $line; 

  if ($i == ($num_of_lines -1) ) {
  	$buffer = $buffer . $line;
  	push (@seqs, $buffer);  #will this work?

  } elsif ($line  =~ /^>/ ) {
	if($debug) {
	  print "Now the header is $line\n";
	  print "    The buffer is $buffer\n";
	}
  	push (@headers,  $line);
	if ( $buffer ne '') { 
	  	push (@seqs, $buffer);  #will this work?
		$buffer= '';   #reset the buffer for a new record
	}
  } else {
  	$buffer = $buffer . $line;
  } 
 }

 my @results = ();
 foreach my $i ( 0 .. $#seqs ) {
   push ( @results, "$headers[$i]\n$seqs[$i]" );
 } 

 return @results;
}



1;
