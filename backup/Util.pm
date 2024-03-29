############################################################
# Utility subroutines for  perl
# Hong Qin
#
#   use lib '/home/hqin/lib/perl/';     use Util ;
############################################################

BEGIN { unshift(@INC,"/home/hqin/lib/perl/");   }



############################################################
# Date:	Nov 7, 2003	Author:Hong Qin
# Usage: $flag = array2hash( \%out_hash, \@keys, \@values );
# Description: return 0 upon success, -1 for umatched array inputs
# Calls ?
# Tested in ?
# Used in  take_coordinates_frm_NC_000964.ptt.by_GI.00.pl on Nov 7, 2003

sub  array2hash {
  use strict; use warnings; my $debug = 0;
  my ( $r_out_hash, $r_keys, $r_values ) = @_;

  if ( ! $r_values ) { $r_values = $r_keys ; }

  my $len1 =  scalar( @$r_keys );  
  my $len2 =  scalar( @$r_values );  

  if ( $len1 != $len2 ) { return -1; }

  for ( my $i=0; $i< $len1; $i += 1 ) {
    $r_out_hash->{ $$r_keys[ $i ] } = $$r_values[ $i ];	  # i am here 110703
  }

  if ($debug) {
   print "Util::array2hash: $len1 keys    @$r_keys \n";
   print "Util::array2hash: $len2 values  @$r_values \n";
   showHashTable( $r_out_hash );
  }

  return 0;
}


############################################################
# Date: Apr 30, 2003 Author: Hong Qin
# Usage: $unmatch_count = count_unmatched_occurence( \@ar1, \@ar2);
# Description:
#	return the number of unmatched occurence
#	0 means complete match. 
#	-1 means uneven length
#	( $ar1[i] eq $ar2[i] );
# Tested in ?
# Used in analyze_exons_coordinates00.pl 

sub count_unmatched_occurence {
 my ( $r_ar1, $r_ar2 ) = @_;  my $debug = 1;
 my @ar1 = @$r_ar1; 	my @ar2 = @$r_ar2;
 my $unmatch_count = 0;
 
 if ( $#ar1 != $#ar2 ) { return -1; }
 
 for( my $i=0; $i<= $#ar1; $i ++) {
   if ( $ar1[ $i ] ne $ar2[ $i ] ) { $unmatch_count ++ ; }
 }
 return  $unmatch_count;
}

############################################################
# Date: Apr 25, 2003 Author: Hong Qin
# Usage: my @lines = grep_fl_by_string( $in_gff_fl, "name=$name" );      
# Description:
# Calls shell grep, use /tmp/, 
#  	my $short_time_stamp = get_short_time_stamp_US();     
# Tested in ?
# Used in sort_flybaseGFF_bylast_entries_00.pl 
 
sub grep_fl_by_string {
 my ($file, $string) = @_;
 my $tmpfl = "/tmp/grep_fl_by_string" . get_short_time_stamp_US(); 

 system (  " grep $string $file > $tmpfl " );
 open (INgrep_fl_by_string, "<$tmpfl" );
 my @lines = <INgrep_fl_by_string>;
 close (INgrep_fl_by_string);

 system ( "rm $tmpfl" );
 return @lines;
}

############################################################
# Date:	Jan 8th, 2003 Author: Hong Qin
# Usage: $flag = parse_paired_ids_by_row(\$in_file,\%pairs);  
# Description:
#  return 1 if success, 0 if failed.  
#  $in_file contains the paired ides, such as p2p intxn data,
#	only the first two ids are used.
#  %pairs stored the ordered and paired ids as keys
# Calls ?
# Tested in ?
# Used in get_intersection_of_two_sets.pl 

sub parse_paired_ids_by_row {
 use strict; use warnings; my $debug = 0;
 my ($ref_file, $ref_pairs) = @_;      

 open IN, "<$$ref_file";
 my @lines = <IN>;
 close IN;

 @lines = grep ( !/^#|^>/, @lines);  # rm annotations

 foreach my $line (@lines) {
   my ( $id1, $id2, @rest ) = split ( /[\s\t]+/, $line );
   if ((defined $id1) and (defined $id2)) {
      my ($big, $small) = order_big2small( $id1, $id2 );
      $$ref_pairs{$big."\t".$small} ++; 
     }
 }
 if ($debug) { 
   print "(Util:)parse_paired_ids_by_row:\n";
   showHashTable( $ref_pairs );	
 }

 return 1;
}



 
############################################################
# Date:120202Mon        Author: Hong Qin
# Usage: %unique_hash1_keys    = hash1_not_in_hash2(\%hash1,\%hash2);    
# Description: return the keys in %hash1 that is not in %hash2
# Calls ?
# Tested in ?
# Used in Merge_meringS2_and_4ProkarInCOG.2.pl

sub hash1_not_in_hash2 {
  use strict; use warnings; my $debug = 0;
  my ( $r_h1, $r_h2 ) = @_;
  my %unique_h1_keys = ();

  foreach my $key ( keys %$r_h1 ) {
    if ( !(exists $r_h2->{$key}) ) {
      $unique_h1_keys{$key} = $r_h1->{$key}; 
    }
  }

  if ($debug) { print "(Util::hash1_not_in_hash2)\%unique_h1_keys:\n";
    showHashTable(\%unique_h1_keys);
  }

  return %unique_h1_keys;
}



############################################################
# Date:120202Mon 	Author: Hong Qin
# Usage: $shared_keys = get_shared_keys(\%hash1, \%hash2);
# Description: return the shared keys in a hash
# Calls ?
# Tested in ?
# Used in Merge_meringS2_and_4ProkarInCOG.2.pl 

sub  get_shared_keys {
  use strict; use warnings; my $debug = 0;
  my ( $r_h1, $r_h2 ) = @_;
  my %shared_keys = ();

  foreach my $key ( keys %$r_h1 ) {
    if (exists $r_h2->{$key} ) {
      $shared_keys{$key} ++;
    }
  }

  if ($debug) { print "(Util::get_shared_keys)\%shared_keys:\n";  
    showHashTable(\%shared_keys);
  }

  return %shared_keys;
}


############################################################
# Date:102302Wed	Author:Hong Qin
# Usage:  Untested. $new_line = remove_white_spaces_of_a_line($line, $delim);   
# Description: s/^[\s\t]+//g, s/[\ \t]+/$delim/g
#	default $delim is "\t"
# Tested in ?
# Used in ??

sub remove_white_spaces_of_a_line {
  use strict; use warnings; my $debug = 0;
  my ($line, $delim) = @_;
  if ( !(defined $delim)) { $delim = "\t" ; }

  my $new_line =~ s/^[\ \t]+//g;
  $new_line =~ s/[\ \t]+/$delim/g;     

  if ($debug) {
    print "(Util::rm_spaces)\$line:[$line]";
    print "(Util::rm_spaces)\$newline:[$new_line]"; 
  }

  return $new_line;
}


############################################################
# Date:102102Mon        Author: Hong Qin
# Usage: $flag = concatenate_hashes(\%large_hash, \%small_hash, \$delim);
# Description: concatenate the %small_hash to %large_hash,
#    default $delim is ' ';
# Calls ?
# Tested in ?
# Used in adic00
 
sub concatenate_hashes {
  use strict; use warnings; my $debug = 0;
  my ($r_large, $r_small, $r_delim) = @_;
  if ( !(defined $_[2]) ) { $$r_delim = ' '; }

  foreach my $key ( keys %$r_small ) {
    $r_large->{$key} .= $r_small->{$key} . $$r_delim  ;
  }

  return 1;
}


############################################################
# Date:102102Mon, 030303Mon	Author: Hong Qin
# Usage: $flag = array_2_file(\$filename, \@lines, \$delim);
# Usage: $flag = array_2_filehandle( $fh, \@lines, \$delim);
# Usage: $flag = array_2_filehandle_with_return( $fh, \@lines, \$delim);
# Description:   Write array to file or file handle.  $delim is optional
#  Return 1 if success, 0 if failed
# Calls ?
# Tested in ?
# Used in adic00

sub array_2_file {
  use strict; use warnings; my $debug = 0;
  my ($ref_fl, $ref_lines, $ref_delim) = @_;

  open (OUT_array_2_file, ">$$ref_fl");
  foreach my $line ( @$ref_lines ) {
    print OUT_array_2_file $line;
    if (defined $ref_delim) { print OUT_array_2_file $$ref_delim; }
  }
  close (OUT_array_2_file);
  return 1;
}

sub array_2_filehandle {
  use strict; use warnings; my $debug = 0;
  my ($fh, $r_lines, $r_delim) = @_;
 
  foreach my $line ( @$r_lines ) {
    print $fh $line;
    if (defined $r_delim) { print $fh $$r_delim; }
  }

 return 1;
}

sub array_2_filehandle_with_return {
  use strict; use warnings; my $debug = 0;
  my ($fh, $r_lines, $r_delim) = @_;
 
  foreach my $line ( @$r_lines ) {
    print $fh $line;
    if (defined $r_delim) { print $fh $$r_delim; }
  }
  print $fh "\n";
 return 1;
}



############################################################
# Date: 101102Fri       Author: Hong Qin
# Usage: $flag = adjacency_list_2_pairs (\%neighbours, \%pairs );
# Description:
#   Return 1 if success, [ 0 if failed, not yet implemented ]
#   The %pairs contain ordered pairs, the value is the occurence after the conversion
# Calls: order_big2small( $string1, $string2);     
# Tested in ?
# Used in network_2_pairs.pl
sub  adjacency_list_2_pairs {
  use strict; use warnings; my $debug = 0;
  my $p_neighbours = $_[0];
  my $p_pairs = $_[1];

 foreach my $head_node ( keys %$p_neighbours ) {      
    my @nodes = split ( /[\s\t]+/, $p_neighbours->{$head_node} );
    foreach my $node (@nodes) {
      my ($big, $small) =  order_big2small($node, $head_node);
      $p_pairs->{$big.' '.$small} ++;
    }
 }
 return 1;
}




############################################################
# Date:100902Wed	Author: Hong Qin
# Usage: %symmetrized_hash = symmetrize_a_hash_by_keys( \%input_hash );  
# Description:  Average the value of by pairwise keys
#   new_value = ( $old{$name1.$name2} + $old{$name2.$name1} ) / 2
# Calls: order_big2small( $name1, $name2 );   
# 	 moran::mean(\@data)
# Tested in ?   
# Used in dijkastra_by_categories.0.0.pl    
  
sub symmetrize_a_hash_by_keys  {
  use moran;
  use strict; use warnings; my $debug = 0;
  my %in_hash = %{$_[0]};
  my %new_hash = ();
  my %strings = ();

  # put values to the string container %strings
  foreach my $key ( keys %in_hash ) {
    my ($name1, $name2) = split( /[\s\t]+/, $key );
    my ($bigger, $smaller) = order_big2small( $name1, $name2 );       
    $strings{$bigger.' '.$smaller} .= $in_hash{$key} . ' ';
  }

  # do the average
  foreach my $key ( keys %strings ) {
    my @data = split ( /[\s\t]+/, $strings{$key} );
    if ( $#data > 1 ) { 
      print "(symmetrize_a_hash_by_keys) More than two values found. Bye.\n"; 
      return undef; 
    }
    $new_hash{$key} = mean(\@data);
  }

  return %new_hash;
}





############################################################
# Date:	092702	Author:Hong Qin
# Usage: $short_name =  get_shortened_name ($filename);
# Description: shorten a file name and return it
# Change 111003 can handle Linux directory

sub get_shortened_name {
  use strict; use warnings; my $debug = 0;
  my $long_name = $_[0];

  my $new_line='';
  my @chars = split ( //, $long_name );
  if ($debug) { print "\@chars=[@chars]\n"; }
  my $char = pop @chars;
  if ($debug) { print "\$char=[$char] \n"; }

  while ( (defined $char ) and ( $char !~ '/' )  ) {
    if ($debug) { print "\$char=[$char] \n"; }
    $new_line .= $char;
    $char = pop @chars;
  }
  if ($debug) { print "\$new_line=[$new_line]\n"; }

  $long_name = reverse $new_line;
  if ($debug) { print "\$long_name=$long_name\n"; }

  my @elements = split (/[\.|\/]+/, $long_name );
  if ($debug) { print "(Util::get_shortened_name)\@elements=[@elements]\n";}
  my @new_elements = ();
  foreach (@elements) {
     if ( $_ gt '' ) { push (@new_elements, $_); }
  }
  @elements = @new_elements;
  if ( $#elements > 1 ) { pop @elements; }
  my $result = join (".", @elements);
  return $result;
}


############################################################
# Date:Dec 2, 2002              Author:Hong Qin
# Usage: hash_2_filehandle3( $fh, \%hash, $dlim1, $dlim2 );
# Usage: hash_2_filehandle3( $fh, \%hash, "\t", "\n");
sub hash_2_filehandle3 {
 use strict; use warnings; my $debug = 0;
 my ($fh, $r_hash, $dlim1, $dlim2 ) = @_;

 my @keys = keys %$r_hash; 
 @keys = sort @keys;
 
 foreach my $key ( @keys ) {
   print $fh "$key$dlim1$r_hash->{$key}$dlim2";
 }
 return;
}


# Date:Sep 2002              Author:Hong Qin
# Usage: hash_2_filehandle($fh, \%hash, \@ordered_keys, \$delimitor);
sub hash_2_filehandle {
 use strict; use warnings; my $debug = 0;
 my ($fh, $ref_hash, $ref_array, $ref_delimitor) = @_;
 
 foreach my $i ( 0..$#$ref_array ) {
   print $fh "$$ref_array[$i]:$$ref_hash{$$ref_array[$i]}$$ref_delimitor";
 }
 print $fh "\n";
 return;
}


# Date:102202Tue             Author:Hong Qin
# Usage: hash_2_filehandle2($fh, \%hash, \@ordered_keys, \$delim_key, \$delim_out);
sub hash_2_filehandle2 {
 use strict; use warnings; my $debug = 0;
 my ($fh, $ref_hash, $ref_array, $r_delim_key, $r_delim_out) = @_;
 
 foreach my $i ( 0..$#$ref_array ) {
   foreach my $j ( 0..$#$ref_array ) {
     my $key = $ref_array->[$i] . $$r_delim_key . $ref_array->[$j];
     print $fh "$$ref_hash{$key}$$r_delim_out";
   }
   print $fh "\n";
 }
 print $fh "\n";
 return;
}




############################################################
# Date:041103Fr               Author:Hong Qin
# Usage:  my $short_date = get_short_date_US();
# Description: return a time stamp in US style, with wkday
# Used in update.pl
#999
sub  get_short_date_US {
  use strict; use warnings; my $debug = 0;
  my ( $second, $minute, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime (time);
  $mon++; 
  my $thisday = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat')[(localtime)[6]];
  if ($mday <10 )  { $mday = "0" . $mday; }
  if ($mon <10  )  { $mon = "0" . $mon; }
  if ($year > 99)  { $year -= 100; }
  if ($year < 10)  { $year = "0" . $year; }
  my $date = "$mon$mday$year$thisday";
  return $date;
}

############################################################
# Date:091502               Author:Hong Qin
# Usage:  my $short_time_stamp = get_short_time_stamp_US();
# Description: return a time stamp in US style
# Used in gbc00 (generate_binary_categories.pl)
 
sub get_short_time_stamp_US {
  use strict; use warnings; my $debug = 0;
  my ( $second, $minute, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime (time);
  $mon++; 
  if ($mday <10 )  { $mday = "0" . $mday; }
  if ($mon <10  )  { $mon = "0" . $mon; }
  if ($year > 99)  { $year -= 100; }
  if ($year < 10)  { $year = "0" . $year; }
  my $time_stamp = "$mon$mday$year.$hour.$minute.$second";
  return $time_stamp;
}

############################################################
# Date:082102Wed		Author:Hong Qin
# Usage:  my $time_stamp = get_time_stamp_US();     
# Description: return a time stamp in US style
# Calls ?
# Tested in ?
# Used in cclu01

sub get_time_stamp_US {
  use strict; use warnings; my $debug = 0;
  my ( $second, $minute, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) = localtime (time);
  $mon++; $year +=1900;  
  my $time_stamp = "$mon/$mday/$year $hour:$minute:$second";
  return $time_stamp;
}



 
############################################################
# Date:082002Wed  Author: Hong Qin
# Usage:  $flag = parse_ordered_ids_by_row(\$in_file,\@ordered_ids);
# Description:
#  return 1 if success, 0 if failed.
#  $in_file is the input file ( elements are /[\s\t]+/ separated)
#   	"^#" and "#>" are comments
#  @ordered_ids is the output
# Calls ?
# Tested in ?
# Used in cclu01

sub parse_ordered_ids_by_row {
 use strict; use warnings; my $debug = 0;
 my ($ref_file, $ref_array) = @_;

 open IN, "<$$ref_file";
 my @lines = <IN>;
 close IN;
 
 @lines = grep ( !/^#|^>/, @lines);

 foreach my $line (@lines) {
   my ( $cat, @rest ) = split ( /[\s\t]+/, $line );
   if (defined $cat) {
      push (@$ref_array, $cat);
     }
 }
 if ($debug) { print "(Util::ordered_ids): [@$ref_array]\n"; }
 return 1;
}


############################################################
# Date:082002Wed  Author: Hong Qin      
# Usage:  $flag = parse_single_network_in_adjList(\$networkfile,\%neighbours,\%dictionary,\$old_header);  
# Description:
#  return 1 if success, 0 if failed.  
#  $network_file is the input file (nodes are tab-delimited!)
#  %neighbours is the output network in adj_list
#  %dictionary is the output dictionary in the $networkfile
#  $old_header is the output header
# To do: a flag to switch dictionary ON or OFF
# Calls ?
# Tested in ?
# Used in cclu01

sub parse_single_network_in_adjList {
  use strict; use warnings; my $debug = 0;
  my ($ref_file, $ref_neighbours, $ref_dictionary, $ref_header) = @_;

  open (IN, "<$$ref_file");   
  my @lines = <IN>; 
  close (IN);

  $$ref_header = shift @lines;  # this is a non-intelligent approach!
  chomp $$ref_header;
 
  foreach my $line ( @lines) {
    my @current_neighbours = ();
    chomp $line;
    my ( $head, @rest ) = split ( /\t/, $line );
    my ( $head_id, $head_category ) = split ( /:/, $head );
    if ( (defined $head_id) and (defined $head_category) ) {
      $$ref_dictionary{$head_id} = $head_category;
      foreach my $partner ( @rest ) {
        my ( $id, $category ) = split ( /:/, $partner );
        if ( defined $id ) {  push ( @current_neighbours, $id );   }
        $$ref_neighbours{$head_id} = join ( ' ', @current_neighbours );
      }
    }
  }
  if ($debug) { 
   print "(Util::parse_network) Network is:\n"; showHashTable($ref_neighbours); 
   print "(Util::parse_network) InDictionary is:\n"; showHashTable($ref_dictionary);
  }
  return 1;
}



############################################################
# Date:	082002Wed	Author: Hong Qin
# Usage:  $flag = parse_dictionary(\$dic_file, \%dictionary, \%oldDefiniton_2_newDefition);   
# Usage:  $flag = parse_dictionary(\$dic_file, \%dictionary );   
# Description:
#   return 1 if success, 0 if failed.
#   $dic_file is the input file name
#   %dictionary stores the output dictionary
#   %oldDefiniton_2_newDefition is the optional translation table
# Calls ?
# Tested in ?
# Used in cclu01

sub  parse_dictionary {
  use strict; use warnings; my $debug = 0;
  my ($ref_dic_file, $ref_dictionary, $ref_tranlation_table) = @_;

  if ($debug>1) { print "(Util::parse_dictionary) $ref_tranlation_table"; }

  open ( IN_parse_dictionary, "<$$ref_dic_file" );
  my @lines = <IN_parse_dictionary>;
  close (IN_parse_dictionary);

  @lines = grep ( !/^#|^>/, @lines);

  foreach my $line ( @lines ) {
    my ( $id, $category, @rest )= split ( /[\s\t]+/, $line);
    if ($debug>1) {
	print "(Util::parse_dictionary) \$id='$id', \$category='$category'\n";
    }
   if ( ( defined $id) and ( defined $category )) { 
      if ( defined %$ref_tranlation_table ) {
         $$ref_dictionary{$id} = $$ref_tranlation_table{$category};
      } else {
         $$ref_dictionary{$id} = $category;
      }
   }
  }
  if ($debug) { print "(Util::parse_dictionary) Dictionary is:\n"; showHashTable($ref_dictionary); }
  return 1;
}




############################################################
# Date: 081502Thu  Author: Hong Qin
# Usage: my %heterogenous_pairs = remove_homodimers(\%input_pairs);   
# Description: remove the self-pairing entries in \%input_pairs
# Tested in ?
# Used in cclu01

sub remove_homodimers {
  use strict; use warnings; my $debug = 0;
  my $ref_in_pairs = $_[0];
  my %heterogenous_pairs = ();

  foreach my $pair(keys %$ref_in_pairs) {
    my ($id1, $id2, @rest ) = split ( /[\s\t\n]+/, $pair);
    if ($id1 ne $id2) {
      $heterogenous_pairs{$pair} = $$ref_in_pairs{$pair};
    }
  }
  return %heterogenous_pairs;
}


############################################################
# Date:	081502Thu	Author: Hong Qin
# Usage: $flag = translate_adjacency_list_2_pairs_by_lookupTable (\%old_neighbours, \%new_pairs, \%lookup_table );
# Description:
#   Replace all names, including the keys in %old_neighbours by %lookup_table
#   Return 1 if success, [ 0 if failed, not yet implemented ]
#   The %new_pairs contain ordered pairs, the value is the occurence after the conversion
#   The keys and values %old_neighbours should all be the keys of %lookup_table
#   Ignore the names that are not in the lookup tables!
# Calls ?
# Tested in ?
# Used in cclu01

sub  translate_adjacency_list_2_pairs_by_lookupTable {
 use strict; use warnings; my $debug = 0;
 my $ref_old_neighbours = $_[0]; 
 my $ref_new_pairs = $_[1];
 my $ref_lookup_table   = $_[2]; 
 my $return_value = 1;

 foreach my $old_key ( keys %$ref_old_neighbours ) {
   my ( $new_key, @new_elements ) = ();
   if ( exists $$ref_lookup_table{$old_key} ) {
     $new_key =  $$ref_lookup_table{$old_key} ;
     my @elements = split ( /[\s\t\n]+/, $$ref_old_neighbours{$old_key} );
     foreach my $element (@elements) {
       if (exists $$ref_lookup_table{$element} ) {
         my ($big, $small) = order_big2small($new_key, $$ref_lookup_table{$element} );  
         $$ref_new_pairs{$big."\t".$small} ++;     #This includes homodiers
       } else { 
	 $return_value = 0;
 	 print "(Util::replace_all_names) $element is not in the lookup table\n";
       }
     }#element
   } else { # header is abnormal
     print "(Util::replace_all_names) $old_key is not in the lookup table\n";
     $return_value = 0;
   }
 }
 return $return_value;
}





 
############################################################
# Date:072302  Author:Hong Qin
# Usage: $largest_symbol =  get_largest_symbol(@symbols);  
# Used in ccom02
# Tested in ?

sub get_largest_symbol {
 use strict; use warnings; my $debug = 0;
 my @symbols = @_;  my $largest_symbol = '';
 
 foreach my $symbol ( @symbols ) {
   if ( $symbol gt $largest_symbol ) { $largest_symbol = $symbol; }
 }
 return $largest_symbol;
}





############################################################
# Date:072302  Author:Hong Qin
# Usage: $flag = all_vertices_BFS (\%neighbours, \%paths )
# Description: Breadth first search. The traveral path is stored in %paths
#       return 0 if failed, 1 if success.
#       %neighbours stores the network in adjacency list format
#	%paths stores the nodes separate by ' '
# Test in ?
# Used in ccom02

sub  all_vertices_BFS {
 use strict; use warnings; my $debug = 0;
 my %neighbours = %{$_[0]}; my $ref_paths = $_[1];

 foreach my $vertex ( keys %neighbours ) {
   my $flag = single_source_BFS (\%neighbours, $vertex, $ref_paths );
   if ( $flag == 0 ) {  print "(Util::allBFS) Failed.\n"; return 0;  }
 }
 return 1;
}



 
############################################################
# Date:072302  Author:Hong Qin
# Usage: $flag = single_source_BFS (\%neighbours, $source, \%paths )
# Description: single source Breadth first search. The traveral path is stored in %paths
#	return 0 if failed, 1 if success.
#	%neighbours stores the network in adjacency list format
#	The $source is stored at the first node in %paths
# Test in ?
# Used in ccom02

sub single_source_BFS  {
 use strict; use warnings; my $debug = 0;
 my %neighbours = %{$_[0]}; my $source = $_[1]; my $ref_paths = $_[2];
 my ( %walk_status, @queue, @temp ) = ();

 foreach my $node ( keys %neighbours  ) {
   $walk_status{$node} = 'N';
 }
 $walk_status{$source} = 'Y';

 $$ref_paths{$source} .= $source.'  ';
 if ($debug) { push (@temp, $source);}
 push ( @queue, $source );
 while ( (scalar @queue) != 0 ) {
   my $current_node = shift @queue;
   my @current_neighbours = split ( /[\s\t]+/, $neighbours{$current_node} );
   foreach my $node ( @current_neighbours ) {
     if ($walk_status{$node} eq 'N') {
       push ( @queue, $node );
       if ($debug) { push (@temp, $node) }
       $$ref_paths{$source} .= $node . '  ';
       $walk_status{$node} = 'Y';
     }
   }
   if ($debug==2) { print "(Util::ssBFS) temp:@temp\n"; }
   $walk_status{$current_node} = 'Y';
 }
 return 1;
}
 
 
############################################################
# Date:081902  Author:Hong Qin
# Usage: $flag = get_nonRedundant_clusters(\%in_clusters,\%nr_clusters, [ \%node_2_cluster_head ] );
# Description: 
#              return 0 if failed, 1 if success.
#              %in_clusters store the clustered nodes in concatenated string.
#              %out_clusters are the non-redundant clusters
#	       %node_2_cluster_head is the optional lookup table
# Calls:
#	 my $largest_symbol =  get_largest_symbol(@elements);
# Tested in ?
# Used in ccluall00

sub get_nonRedundant_clusters {
 use strict; use warnings; my $debug = 0;
 my $ref_in_clusters = $_[0];
 my $ref_out_clusters = $_[1];
 my $ref_node_2_cluster_head = undef;
 if (defined $_[2]) { $ref_node_2_cluster_head = $_[2]; }

 foreach my $node ( keys %$ref_in_clusters ) {
   my @elements = split ( /\s+/, $$ref_in_clusters{$node}  );
   my $largest_symbol =  get_largest_symbol(@elements);

   if ( ! exists $$ref_out_clusters{$largest_symbol} ) {
     $$ref_out_clusters{ $largest_symbol } = $$ref_in_clusters{ $node }  ;
   }

   if (defined $ref_node_2_cluster_head ) {
     $$ref_node_2_cluster_head{ $node } = $largest_symbol;
   }
 }
 return 1 ;
}



############################################################
# Date:081502  Author:Hong Qin
# Usage: $flag = all_sources_BFS_on_same_colored_nodes (\%neighbours, \%same_color_clusters,\%dictionary)  
# Description: Iterate all vertice for BFS with category
#              return 0 if failed, 1 if success.
#              %neighbours is a linked list formate of a graph. elements are separated by /[\s\t]+/
#              %same_color_clusters store the clustered nodes in concatenated string.
#              %dictionary stores the "color" look up table
# Calls:  single_source_BFS_on_same_colored_nodes ()
# Tested in ?
# Used in color_clusters0.1.pl

sub  all_sources_BFS_on_same_colored_nodes {
 use strict; use warnings; my $debug = 0;
 my $ref_neighbours = $_[0]; 
 my $ref_same_color_clusters = $_[1];
 my $ref_dictionary = $_[2] ;

 foreach my $node ( keys %$ref_neighbours ) {
  my $flag = single_source_BFS_on_same_colored_nodes ( $ref_neighbours, $node,
                                        $ref_same_color_clusters, $ref_dictionary );
  if ($debug) {
     print "(Util.all_BFS_cat) $node : $$ref_same_color_clusters{$node} \n";
  } 
 }
 return 1;
}


 
############################################################
# Date:071802  Author:Hong Qin
# Usage: $flag = single_source_BFS_on_same_colored_nodes (\%neighbours, $source, 
#					 \%same_color_clusters,\%dictionary) 
# Description: Modified single_source BFS on the same colored nodes
#	       return 0 if failed, 1 if success.
#	       %neighbours is a linked list formate of a graph. elements are separated by /[\s\t]+/
#	       %same_color_clusters store the clustered nodes in concatenated string.
#	       %dictionary stores the "color" look up table
# Tested in ?
# Used in color_clusters0.0.pl

sub single_source_BFS_on_same_colored_nodes {
 use strict; use warnings; my $debug = 0;  
 my %neighbours = %{$_[0]};  my $source = $_[1];  
 my $ref_same_color_clusters = $_[2];  
 my %dictionary = %{$_[3]} ;
 my ( %walk_status, @queue  ) = ( );
 my @temp = ();

 if ($debug==2) {
   print "------Util.pm-----\n";
   showHashTable(\%neighbours);
   showHashTable(\%dictionary);
   showHashTable( $ref_same_color_clusters);
 }

 foreach my $node ( keys %neighbours  ) {
   $walk_status{$node} = 'N';
 }
 $walk_status{$source} = 'Y';
 
 $$ref_same_color_clusters{$source} .= $source.'  ';
 if ($debug) { push (@temp, $source);}
 push ( @queue, $source );
 while ( (scalar @queue) != 0 ) {
   my $current_node = shift @queue;
   my $current_color = $dictionary{$source};
   my @current_neighbours = split ( /[\s\t]+/, $neighbours{$current_node} );
   foreach my $node ( @current_neighbours ) {
     if (($walk_status{$node} eq 'N') and ($dictionary{$node} eq $current_color)) {
       push ( @queue, $node );
       if ($debug) { push (@temp, $node) }
       $$ref_same_color_clusters{$source} .= $node . '  ';
       $walk_status{$node} = 'Y';
     }
   }
   if ($debug) { print "(Util::ssBFS) temp:@temp\n"; }
   $walk_status{$current_node} = 'Y';
 }
 return 1;
}


############################################################
# Date:071602  Author:Hong Qin
# Usage: @longest_list =  get_longest_lists( @array_of_lists );     
# Description: each $line in @lines contains a list of @elements,
#              The @elements are separated by /[\s\t\n]+/
# Tested in 
# Used in ?

sub  get_longest_lists {
  use strict; use warnings; my $debug = 0;
  my @array_of_lists = @_;
 
  my ( @longest_lists, @elements, $max, $list ) = ();
  $max = 0;

  foreach $list ( @array_of_lists ) {
    @elements = split ( /[\s\t]+/, $list );
    if ( $max < ($#elements +1) ) {
       # empty the buffer and reset
       @longest_lists = ();
       push ( @longest_lists, $list);
       $max = $#elements + 1;
    } elsif ( $max == ($#elements +1) ) {
       # put the current list into buffer
       push ( @longest_lists, $list);
    }
  }
  return @longest_lists;
}




############################################################
# Date:071602  Author:Hong Qin
# Usage: @new_lines = single_linkage_cluster_on_array_of_list ( @lines )
# Description: each $line in @lines contains a list of @elements,
#              The @elements are separated by /[\s\t\n]+/
# Calls 
# 	sub one_step_single_linkage_cluster_on_headList ( @lines )        
# 	sub single_linkage_cluster_on_head_list( @lines );    
# Tested in cluster1.pl
# Used in cc01

sub single_linkage_cluster_on_array_of_list {
  use strict; use warnings; my $debug = 0;
  my @lines = @_;
  
  my ( @clusters ) = ();
  my ( $line, $head_list, @new_lines ) =();
  my $change_flag = 'Y';
  my $done = 'N';
  
  while ( $done eq 'N' ) {
    @new_lines =  single_linkage_cluster_on_head_list( @lines); 
    if ( ( $#new_lines == 0 ) or ( $#new_lines == 1 ) ) {  
	$done = 'Y';
	push ( @clusters, @new_lines );
	if ($debug) { print "(Util::cluster) stored new_lines[0]:$new_lines[0]\n";
		      print "                stored new_lines[1]:$new_lines[1]\n"; 
	}    
    } else {
        $head_list = shift @new_lines;
        push ( @clusters, $head_list );
        @lines = @new_lines;
        if ($debug) { print "(Util::cluster) stored head_list:$head_list\n" }
    }
  }
  return @clusters;
}





############################################################
# Date:071602  Author:Hong Qin
# Usage: @new_lines = one_step_single_linkage_cluster_on_headList( @lines )
# Description: each $line in @lines contains a list of @elements, 
#	       The @elements are separated by /[\s\t\n]+/
#	       This sub is designed to be used iteratively.
# Tested in cluster1.pl
# Used in ?

sub one_step_single_linkage_cluster_on_headList {
  use strict; use warnings; my $debug = 0;
  my @lines = @_;
  my ( $line,  $head_list, @elements, $element, @hits, @buffers, $buffer ) = ();

  $head_list = shift @lines;
#  print "head: $head_list\n";
  @elements = split ( /[\s\t\n]+/, $head_list );

  foreach $element ( @elements ) {
    if ( $element ne '') {
      @hits = grep   /$element/, @lines ;
      if ($debug) { print "(Util::one_step) hits($element): @hits\n"; }
#      print "lines: @lines\n";
      push ( @buffers, @hits );
    }
  }

  if ($debug) { print "(Util::one_step) buffers: @buffers\n" }   

  if ( @buffers == 0 ) { unshift (@lines, $head_list) ; return @lines ; } 

  unshift ( @buffers, $head_list );
  $buffer = join ( ' ', @buffers ) ;
  @elements = split ( /[\s\t\n]+/, $buffer ) ;

  my %nr_elements = ();

  foreach $element ( @elements ) {
    if ( $element ne '') {  $nr_elements{ $element } ++; }
  }

  $head_list = join ( ' ', keys %nr_elements );
  if ($debug) { print "(Util::one_step) head list: $head_list \n"; }

  my @new_lines = ();
  foreach $line ( @lines ) {
     my $hit_status = 'Y';     my $i = 0;
     $line =~ s/^\s+//g; # will this adjust the begining?
     @elements = split ( /[\s\t\n]+/, $line );
     if ($debug) { print "(Util::one_step) elements are:[@elements]\n"; }    
     while (( $i<= $#elements) and ($hit_status eq 'Y')) {
       if ( ! exists $nr_elements{ $elements[$i] })  { $hit_status = 'N' }
       if ($debug) { print "(Util::one_step) element[$i] is:[$elements[$i]]\n"; }    
       $i++;
     }

     if ($hit_status eq 'N') {
	push ( @new_lines, $line);
     }
  }

  unshift ( @new_lines, $head_list );
  if ($debug) { 
    print "(Util::one_step) new_lines are:@new_lines\n";
    print "(Util::one_step) successfully return\n\n\n";   
  }     
  return @new_lines;
}




############################################################
# Date:	071602	Author: Hong Qin
# Usage: @new_lines = single_linkage_cluster_on_head_list( @lines );
# Description: 
# Calls one_step_single_linkage_cluster_on_headList( @lines )   
# Tested in cluster1.pl
# Used in ?

sub single_linkage_cluster_on_head_list {
  use strict; use warnings; my $debug = 0;
  my @lines = @_;
  my $change_flag = 'Y';

  while ( $change_flag eq 'Y' ) {
    my @new_lines = one_step_single_linkage_cluster_on_headList( @lines );
    if ( $#new_lines == $#lines ) {
      $change_flag = 'N';
    } else {  
      $change_flag = 'Y';
      if ($debug) { print "(Util::upper call) head:[$new_lines[0]]\n"; }
      @lines = (); @lines = @new_lines;
    }  
  }

  if ($debug) { print "(Util::upper call) successfully exit\n"; }        
  return @lines;
}









##############################################################
# Usage: %all_nr_pairs = get_all_nr_pairs (\@all_neighbouring_nodes );
# Note: pick random pairs from high-conneted ones to low ones.  Avoid self-interactions.
# Must call seed() before using this sub

sub get_all_nr_pairs {
  use strict; use warnings; 
  my $debug = 0;
  my ( @neighbouring_nodes ) = @{$_[0]};
  my ( %nr_pairs, ) =();     
  my $window = 10;
  my ( $current, $next, $pair_id, $big, $small, $count, $size1, $size2 ) = ();

  while ( (scalar  @neighbouring_nodes) != 0 ) {

    if ( @neighbouring_nodes == 2 ) { $current = 0; $next =1;
    } else {
      	$size1 =  scalar @neighbouring_nodes ;
    	$current = int (rand $size1) ;  
#    	print "[current: $current] \t";
    	$next = int (rand $size1); 
    	while ( $neighbouring_nodes[$next] eq $neighbouring_nodes[$current] ) {
      		$next = int (rand $size1);   
    	}
#    	print "[next: $next ] \t";
    } #else 

    ( $big, $small ) =  order_big2small( $neighbouring_nodes[$next],  $neighbouring_nodes[$current] );
    $pair_id = $big."\t".$small;
    if ( exists $nr_pairs{$pair_id} ) {
	#take the last 5 out
	$count = 5;
	my @pair_ids = keys %nr_pairs;
	while ( ($count > 0) and ( @pair_ids > $window ) ) {
          $size2 = scalar @pair_ids ;
	  my $position = int (rand $size2 );
	  $pair_id = $pair_ids[$position];
	  if ( $position == $#pair_ids  ) { 
		pop @pair_ids; 
	  } else {
		splice ( @pair_ids, $position, 1);
	  }
	  delete $nr_pairs{$pair_id};
	  ( $big, $small ) = split ( /\t/, $pair_id );
	  push ( @neighbouring_nodes, $big, $small);
	  $count -- ;
    	  if ( $debug ) { print "(Util::get_all_nr_pairs1) Total neighbouring nodes are now:"
		.(scalar @neighbouring_nodes)."\n";
    	  }
	} # while
    } else {
	$nr_pairs{$pair_id} = 1;
	if ( $#neighbouring_nodes == 1 ) { @neighbouring_nodes = (); 
	} else {
		if ( $current == $#neighbouring_nodes ) { 
			pop  @neighbouring_nodes; 
		} else {
			splice ( @neighbouring_nodes, $current, 1);
		}
	       	if ($debug) {print "\n(Util::get_all_nr_pairs2) Total neighbouring nodes are now:".(scalar @neighbouring_nodes)." after splice $current \n";}
		if ( $next > $current) { $next  --; }
		if ( $next == $#neighbouring_nodes  ) {
			pop @neighbouring_nodes; 
		} else {
			splice ( @neighbouring_nodes, $next, 1);
		}
	 	if ($debug) { print "(Util::get_all_nr_pairs3) Total neighbouring nodes are now:".(scalar @neighbouring_nodes)." after splice $next\n"; }
    	}#else
    }#else  
  } #while
#  print "leaving Util:::get_all_nr_pairs\n";
  return %nr_pairs;
}



############################################################
# Date:	081502Thu	Author: Hong Qin
# Usage: $flag = pairwise_to_adjacency_list(\%pairwised_ids, \%neighbours);
# Description:
#    Convert a network in pairwise format(edges) to adjacency list format
# Note: 
#    Weight values for the edges are ignored on 081502
# Design:
#    Iterate through the pairs, and concatenate and the paired nodes into %neighbours
# Calls ?
# Tested in ?
# Used in cclu01

sub pairwise_to_adjacency_list {
  use strict; use warnings; my $debug = 0;
  my $ref_pairs = $_[0];
  my $ref_neighbours = $_[1];
  my $result = 1;

  foreach my $pair (keys %$ref_pairs) {
    my ($id1, $id2) = split (/[\s\t]+/, $pair);
    $$ref_neighbours{$id1} .= $id2."\t";
    $$ref_neighbours{$id2} .= $id1."\t";
  }
  return $result;
}



####################################################################
# Usage: @linked_list = convert_pairwise_to_linked_list(\%pairwised_ids, \@unique_ids);
# 	@linked_list are delimited by "\t"
# used in "gn2"
# tested in ?

sub convert_pairwise_to_linked_list{
  use strict; use warnings;
  my %pairs = %{$_[0]};
  my @nr_nodes = @{$_[1]};
  my @linked_list = ();

  foreach my $node (@nr_nodes) {
    my @partners = ();
    foreach my $pair ( keys %pairs ) {
      if ( $pair =~ m/$node/ ) {
        my ($node1, $node2) = split ( /[\s\t]+/, $pair );
        if ($node1 eq $node) { push ( @partners, $node2 ); 
        } elsif ( $node2 eq $node ) { push ( @partners, $node1 ); }
      } # if $pair
    } # foreach $pair 
    unshift ( @partners, $node) ;
    my $tmp = join( "\t",  @partners );
    push ( @linked_list, $tmp );
  } #$node

  return @linked_list;
}



 
 
####################################################################
# Usage: @linked_list = attach_categories(\@linked_list, \%categoires);
# used in "ccom02"
# tested in ?

sub attach_categories {
  use strict; use warnings;
  my @lines = @{$_[0]};
  my %categories = %{$_[1]};
  my @new_lines = ();

  foreach my $line ( @lines ) {
    my @ids = split ( /[\s\t]+/, $line );
    my $new_line = '';
    foreach my $id (@ids) {
      $new_line .= $id.":".( $categories{$id} )."\t";
    }
    push ( @new_lines, $new_line );  
  }

  return @new_lines;
}



####################################################################
# Usage: %pairs = get_pairs(\@data);
# Convert sequencial entries to pairs
# used in ?
# tested in p-sort.pl
# Note: This subroutine does not detect repeated pairing!!!

sub get_pairs{
 use strict; use warnings;
 my @data = @{$_[0]};  my $debug = 0;
 my %pairs = ();
 my $end ;

 if ( $debug ) { print "(Util::get_pairs) Do not use this sub.\n"; }
 if ( (int ($#data /2 )) == ($#data /2 ) ) { $end = $#data -2 ;
 } else { $end = $#data -1 ;}

 for ( my $i=0; $i <= $end; $i +=2 ) {
   my ($bigger, $smaller) = order_big2small( $data[$i], $data[$i+1]);       
   my $pair_id = $bigger."\t".$smaller;
   $pairs{$pair_id} = 1;
 }
 return %pairs;
}

 
############################################################
# Usage: @array_without_self_pairing_at_even_positions = remove_self_pairing_at_even_position(\@data);
# Return an array that do not contain self-pairs beginning at even positions
# Note: treat @data as strings
# used "gn2"
# tested in t-sort.pl
# depends on get_first_tandem_repeats_at_even_positions(\@data);    
# depends on rand().  Must call srand(time ^ $$ ^ unpack "%32L*", 'ps axww|gzip')  
# 	before using this subroutine
# Note: THIS DOES NOT DETECT REPEATED PAIRINGS.

sub remove_self_pairing_at_even_position {
 use strict; use warnings;
 my @data = @{$_[0]};  my $debug = 0;

 my $pos_of_first_pair = get_first_tandem_repeats_at_even_positions(\@data);    

 while ( $pos_of_first_pair != -1 ) {
   #switch the element of the first pairs with any random element
   my $another = rand ( scalar @data );
   while ( $another == $pos_of_first_pair ) { $another = rand ( scalar @data );  }
#   my $tmp = $data[$pos_of_first_pair];
#   $data[$pos_of_first_pair] = $data[$another];
#   $data[$another] = $tmp;
   ( $data[$pos_of_first_pair], $data[$another] ) = ( $data[$another], $data[$pos_of_first_pair] );
   $pos_of_first_pair = get_first_tandem_repeats_at_even_positions(\@data);  
 }

 return @data;
}
 
############################################################
# Usage: $index = get_first_tandem_repeats_at_even_positions(\@data);
# Return the first index of trandem repeats beginning at even positions
# Note: treat @data as strings
# used ?
# tested in t-sort.pl
# NOTE: THIS DOES NOT DETECT INERSPERSED REPEATED-PAIRINGS
 
sub get_first_tandem_repeats_at_even_positions {
 use strict; use warnings;
 my @data = @{$_[0]};  my $debug = 0;
 my $end ;

 if ( (int ($#data /2 )) == ($#data /2 ) ) { $end = $#data -2 ;
 } else { $end = $#data -1 ;}
 
 if ($debug) { print "(Util::tandem...)  $end \n"; } 

 for (my $i = 0; $i <=  $end  ; $i +=2 ) {
    if ( $data[$i] eq $data[$i+1] ) { return $i ; }
  }
 return -1;
}

 
 
############################################################
# Usage: ($bigger, $smaller) = order_big2small( $string1, $string2);
# used in "generate_null_networks2.pl  ; alias = gn2 "
# tested in t-sort.pl

sub order_big2small {
 use strict; use warnings;
 my ( $string1, $string2) = @_;

 if ( $string1 ge $string2 ) { return ($string1, $string2); 
 } else { return ($string2, $string1); }
}


############################################################
# Date: 071802
# Usage: @big_2_small_elements = order_big2small_array( @elements);
# Used in  color_clusters0.0.pl    

# This subroutine seems to have serious bugs. 072302
 
sub order_big2small_array {
 use strict; use warnings;
 my @elements = @_;
 my ( $i, $j, $n, $tmp ) = ();

 foreach $i ( 0..$#elements ) {
  foreach $j ( $i..$#elements ) { 
   if ( $elements[$i] lt $elements[$j] ) {
     $tmp = $elements[$i];
     $elements[$i] =  $elements[$j];
     $elements[$j] = $tmp;
   }
  }#$j
 }# $i
 return @elements;
}



############################################################
# Usage: @nonredunt_elements = get_nonredundant_elements ( \@elements );
# This is designed to generate the nonredundant elements from an input array
# used in generate_linked_list_configuration_file.pl on 061102Tue  

sub get_nonredundant_elements {
  use strict; use warnings; my $debug = 0;
  my @elements = @{$_[0]};
  my ( %nr_elements, $element ) = ();

  foreach $element ( @elements ) {
    $nr_elements{ $element } = 1;
  }

  return keys (%nr_elements)
}




############################################################
# Usage: %nr_pairs = get_nonredundant_unordered_pairs2( \@pair1_in_lines, \@pair2_in_lines );
# This is designed to generate the nonredundant p2p pairs from two input arrays
# The two input arrays contain tab/space delimited pairs of identifiers.
# The paired identifiers are not in any orders. 
# used merge_two_sets_of_pairs.pl     
# changed on 091902 to deal with extra input data

sub get_nonredundant_unordered_pairs2 {
  use strict; use warnings; my $debug = 0;
  my @pair1_in_lines = @{$_[0]};
  my @pair2_in_lines = @{$_[1]};
  my ( %merged_hash  ) = ();
  my ($name1,$name2, $key, $rev_key, $line, @rest);

  foreach $line ( @pair1_in_lines ) {
    ( $name1, $name2, @rest ) = split ( /[\t\s]+/, $line);  # 091902
    $key = $name1."\t".$name2;  
    $rev_key = $name2."\t".$name1;
    if ( exists $merged_hash{$key} ) {  $merged_hash{$key}++; }
    elsif ( exists  $merged_hash{$rev_key})  {  $merged_hash{$rev_key}++;}
    else { $merged_hash{$key} = 1; }
  }

  foreach $line ( @pair2_in_lines ) {
    ( $name1, $name2, @rest ) = split ( /[\t\s]+/, $line);  #091902
    $key = $name1."\t".$name2;
    $rev_key = $name2."\t".$name1;
    if ( exists $merged_hash{$key} ) {  $merged_hash{$key}++; }
    elsif ( exists  $merged_hash{$rev_key})  {  $merged_hash{$rev_key}++;}
    else { $merged_hash{$key} = 1; }
  }

  return %merged_hash;
}


############################################################
# Usage: %shared_pairs = get_shared_pairs( \%hashTable1, \%hashTable2 );
# Precodition: key-value orders are reversed in the two input hashtables
#	       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# Tested in intersection.pl
# used in merge_two_sets_of_pairs.pl , get_shared_pairs.pl     

sub  get_shared_pairs {
  use strict; use warnings; my $debug = 0;
  my %hashTable1 = %{$_[0]};
  my %hashTable2 = %{$_[1]};
  my ( $shared_pairs, %rev_hashTable2, %mergedHash1, %mergedHash2 ) = ();
  my ($key,$value, $newkey);
 
  #reverse the 2nd hash
  while ( ($key,$value) = each(%hashTable2) ) {
    if ($debug) {print "$key => $value\t";}
    $rev_hashTable2{$value}=$key;
  }

  if ($debug) {    print "\n-----Util-Begin--merge the first hash--\n";    }  

  # merge the key-value in the hash tables;
  while ( ($key,$value) = each(%hashTable1) ) {
    if ($debug) {print "$key => $value\t";}
    $newkey =  $key."\t".$value;
    $mergedHash1{ $newkey  } = 0;
  }

  if ($debug) {print "\nNow merge the second hash\n";}  
  while ( ($key,$value) = each(%rev_hashTable2) ) {
    if ($debug) {print "$key => $value\t";}
    $newkey =  $key."\t".$value;
    $mergedHash2{ $newkey } = 0;
  }

  if ($debug) {
  showHashTable( \%mergedHash1); print "\n\n"; 
  showHashTable( \%mergedHash2); print "\n";  print "-----Util-Ends----\n";
  }

  # get the intersection of the two merged hashes
  $shared_pairs = intersection ( \%mergedHash1, \%mergedHash2 );

  return %{$shared_pairs};
}





############################################################
# Usage: @lines = remove_white_spaces(@lines);
# Remove only " "s (not \t \n etc ) and merge redundant tabs into only one.
# used in merge_two_sets_of_pairs.pl 
# not completely tested yet

sub  remove_white_spaces {
  use strict; use warnings; my $debug = 0;
  my @lines = @_;

  foreach my $line (@lines) {
    $line =~ s/[\ \t]+/\t/g;
    if ($debug) { print "(Util.remove_white_spaces)$line\n"; }
  }
  return @lines;
} 
 




 
############################################################
# Usage: write_hash2file(\%hash, $outfile, "\t");  
# used in get_shared_pairs.pl, merge_two_sets_of_pairs.pl  
# not completely tested yet
# Changed 090902

sub  write_hash2file {
  use strict; use warnings;
  my %hash = %{$_[0]};
  my $filename = $_[1];
  my $separator = $_[2];
  my ($key,$value) = ();

  my @ordered_keys = sort (keys %hash);  # added 090602
   
  open ( _OUTPUT_write_hash, ">$filename" );  
  foreach $key (@ordered_keys) {   # 090602 
    $value = $hash{$key};
    if (defined $value) {  # change 090902
        print  _OUTPUT_write_hash "$key$separator$value\n";  # changed on 052902
    } else { 	#for null value
        print  _OUTPUT_write_hash "$key\t undefined\n";
    }
  }   
  close ( _OUTPUT_write_hash );
}

 

############################################################
# Usage: set_hash(\%hash1, \@lines, "\t" );   
#        set_hash(\%hash1, \@lines, $separator );   
# Precodition: use an array to set a hashtable. 
#  The array may contain the lines from a file.  Each line
# can be split into a key and a value by the specified separator.
# used in  get_shared_pairs.pl           
# Note: The keys must be unique, otherwise only one value is stored!
#       ^^^^^^^^^^^^^^^^^^^^^^^

sub set_hash {
  use strict; use warnings; my $debug = 0;
  my $hash = $_[0];
  my @lines = @{$_[1]};  
  my $separator = $_[2];
  my ($key, $value, $rest) = ();

  foreach my $line ( @lines ) {
     chomp $line;
     ($key, $value, $rest) = split ( /$separator/, $line );
     if ( ( $key) && ($value) ) {
        $$hash {$key} = $value;
     }
  } 

  if ($debug)  {
    print "---Begin in set_hash--\n";
    showHashTable($hash);
    print "---End in set_hash--\n";
  }
  return;
}




#______________________tested:_____________________________________

############################################################
# Usage:  %intersection = intersection( \%hash1,\%hash2 )
# Modified from "Mastering algorithms with perl"
# Tested in intersection.pl

sub intersection {
  use strict; use warnings; my $debug = 0;
  my ($i, $sizei ) = ( 0, scalar keys(%{ $_[0] }) );
  my ($j, $sizej);

  # find the smallest hash to start
  for ( $j = 1; $j < @_; $j++ ) {
     $sizej = keys %{ $_[$j] };
     ( $i, $sizei ) = ( $j, $sizej ) if $sizej < $sizei;
  }

  # reduce the list of possible elements by each hash in turn
  my @intersection = keys(%{ splice @_, $i, 1 });
  my $set;
  while ( $set = shift ) {
     @intersection = grep { exists $set->{ $_ } } @intersection;
  }

  my %intersection;
  @intersection{ @intersection } = ();
  
  return \%intersection;
}


############################################################
# Usage: showHashTable2(\%hashTableInput, $lowest_value);
# Only show values that are higher that the $lowest_value (not including)
#
sub showHashTable2 {
  use strict; use warnings;
  my %hashTable = %{$_[0]};
  my $limit = $_[1];
  my ($key,$value);
 
  while ( ($key,$value) = each(%hashTable) ) {
    if ( $value >= $limit) {   #041903
      print "$key => $value\t";
    }
  }
  print "\n";
}

##############################################################
# Usage: showHashTable(\%hashTableInput);
# Upadate on 091702 for ordered keys
# Updated on 090902 to treat undefined values

sub showHashTable {
  use strict; use warnings;
  my %hashTable = %{$_[0]};

  my @keys = sort (keys %hashTable);
  my $count = $#keys + 1;
  
  foreach my $i ( 0 .. $#keys ) {
#  while ( ($key,$value) = each(%hashTable) ) {      
    my $value = $hashTable{$keys[$i]};
    if (!(defined $value) ) { $value = 'undefined'; }
    print "$keys[$i] => $value\t";
  }
  print "\n(Util.showHashTable)There are $count pairs in the above hash table.\n";
}

1;
