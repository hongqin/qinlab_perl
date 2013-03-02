############################################################
# subroutines for Graph analysis
# Hong Qin
# To use this module, put following lines
#  use lib '/shar/lib/perl/';     use Graph; 
#
############################################################



############################################################
# Date: 100802Tue  Author: Hong Qin
# Usage: $flag = all_sources_symmetrical_DijDists_by_cats(\%neighbours, \%dictionary, \%avg_dists_by_cats, \%std_by_cats)
# Description:
#   Calculate the shorstest path from all sources to all categories found in %neighbours
# Strategy:
#   store single_source results in a string container, then do the summary statistics
# Calls: single_source_shortestDistances_by_categories(\%neighbours, $source, \%dictionary, \%dists_by_cats);
#       moran::mean(\@data)
#       moran:: standard_deviation_data(\@array)
#	Util::order_big2small( $string1, $string2);     
# Tested in  test_dijkasta.pl
# Used in ?

sub all_sources_symmetrical_DijDists_by_cats {
  use moran;  use Util; use strict; use warnings; my $debug = 2;
  my ($p_neighbours, $p_dictionary, $p_avg_dists_by_cats, $p_std_by_cats) = @_;
  my $flag = 1;
  my %string_dists_by_cats = ();
  my $count = 0;
  
  # iterate all nodes, put result to string_container
  foreach my $s ( keys %$p_neighbours ) {
    if ($debug>1) {
      open (TMP, ">>__sym_tmp");
      $count ++;
      print TMP "$count \t"; 
      close (TMP);
    }
    my %single_source_dists_by_cats = ();
    $flag = single_source_shortestDistances_by_categories($p_neighbours, $s, $p_dictionary, \%single_source_dists_by_cats);
    foreach my $key (keys  %single_source_dists_by_cats ) {
      my ($id1, $id2 ) = split ( /[\s\t]+/, $key  );
      my ($big, $small) = order_big2small($id1, $id2);
      $string_dists_by_cats{$big.' '.$small} .= $single_source_dists_by_cats{$key} . ' ';
    }
  }

  # do summary statistics
  if (defined $p_std_by_cats) {
    foreach my $key ( keys %string_dists_by_cats ) {
      my @data = split ( /[\s\t\n]+/, $string_dists_by_cats{$key} );
      $p_avg_dists_by_cats->{$key} = mean(\@data);
      $p_std_by_cats->{$key} =  standard_deviation_data(\@data);
    }
  } else {
    foreach my $key ( keys %string_dists_by_cats ) {
      my @data = split ( /[\s\t\n]+/, $string_dists_by_cats{$key} );
      $p_avg_dists_by_cats->{$key} = mean(\@data);
    }
  }

  return $flag;
}

 
############################################################
# Date: 100802Tue  Author: Hong Qin
# Usage: $flag = all_sources_shortestDistances_by_categories(\%neighbours, \%dictionary, \%avg_dists_by_cats, \%std_by_cats);  
# Description:
#  Calculate the shorstest path from all sources to all categories found in %neighbours
# Strategy:
#  Store single_source results in a string container, then do the summary statistics
# Calls: single_source_shortestDistances_by_categories(\%neighbours, $source, \%dictionary, \%dists_by_cats);  
#     	moran::mean(\@data)
#	moran:: standard_deviation_data(\@array)      
# Tested in test_dijkasta.pl
# Used in ?

sub all_sources_shortestDistances_by_categories {
  use moran;
  use strict; use warnings; my $debug = 2;
  my ($p_neighbours, $p_dictionary, $p_avg_dists_by_cats, $p_std_by_cats) = @_;
  my $flag = 1;
  my %string_dists_by_cats = ();
  my $count = 0;

  # iterate all nodes, put result to string_container
  foreach my $s ( keys %$p_neighbours ) {
    if ($debug>1) {
      open (TMP, ">>__shortest_path_tmp");
      $count ++;
      print TMP "$count \t"; 
      close (TMP);
    }
    my %single_source_dists_by_cats = ();
    $flag = single_source_shortestDistances_by_categories($p_neighbours, $s, $p_dictionary, \%single_source_dists_by_cats); 
    foreach my $key (keys  %single_source_dists_by_cats ) {
      $string_dists_by_cats{$key} .= $single_source_dists_by_cats{$key} . ' '; 
    }
  }
  
  # do summary statistics
  if (defined $p_std_by_cats) {
    foreach my $key ( keys %string_dists_by_cats ) {
      my @data = split ( /[\s\t\n]+/, $string_dists_by_cats{$key} );
      $p_avg_dists_by_cats->{$key} = mean(\@data);
      $p_std_by_cats->{$key} =  standard_deviation_data(\@data);
    }
  } else {
    foreach my $key ( keys %string_dists_by_cats ) {
      my @data = split ( /[\s\t\n]+/, $string_dists_by_cats{$key} );
      $p_avg_dists_by_cats->{$key} = mean(\@data);
    }
  }

  return $flag;
}


############################################################
# Date:	100802Tue  Author: Hong Qin
# Usage:  $flag = single_source_shortestDistances_by_categories(\%neighbours, $source, \%dictionary, \%dists_by_cats);
# Description: 
#   Calculate the shorstest path from $source to all categories found in %neighbours
#   The keys in %dists_by_cats are in the order: $source_cat.' '.$destination_cat
# Calls  $flag = dijkstra(\%neighbours, $source, \%distances, \%predecessors);        
# Tested in  test_dijkasta.pl 
# Used in ?

sub single_source_shortestDistances_by_categories {
  use strict; use warnings; my $debug = 0;
  my ($p_neighbours, $s, $p_dictionary, $p_dists_by_cats) = @_;
  my $flag = 1;
  my %predecessors = ();
  my %distances = (); 

  $flag = dijkstra( $p_neighbours, $s, \%distances, \%predecessors );    

  my $s_cat = $p_dictionary->{$s};

  my %rest_nodes = %$p_neighbours;
  delete $rest_nodes{ $s };

  foreach my $node (keys %rest_nodes ) {
    my $v_cat = $p_dictionary->{ $node };
    my $key = $s_cat . ' ' . $v_cat;   # The order is important here.
    if (defined $p_dists_by_cats->{$key} ) {
      if ( $p_dists_by_cats->{$key} > $distances{ $node }  ) {
         $p_dists_by_cats->{$key} =  $distances{ $node } ;
      }
    } else {
      $p_dists_by_cats->{$key} = $distances{ $node };
    }
  }

  return $flag;
}




############################################################
# Date: 100802Tue	Author:Hong Qin
# Usage:  $flag = dijkstra(\%neighbours, $source, \%distances, \%predecessors, \%weights);  
# Description: Dijkstra shortest path for single source
#  p527, TH Cormen, CE Leiserson, RL Riverst, "Introduction to Algorithms"
#  Return 1 if success, 0 if failed.  
# Calls:
#  $flag = relax($u, $v, $w, \%distances, \%predecessors); 
#  $flag = initialize_single_source(\%neighbours, $source, \%distances, \%predecessors);      
#  $u = extract_min(\@Queue, $p_distances, \%Solved);    
# Tested in  test_dijkasta.pl  
# Used in ?
# Note the \%weights are not implemented here!!!

sub dijkstra {
  use strict; use warnings; my $debug = 0;
  my ($p_neighbours, $s, $p_distances, $p_predecessors, $p_weights ) = @_;    
  my $flag = 1;

  if (defined $p_weights) { print "(dijkastra)Weights are not implemented. Bye.\n"; return 0; }

  $flag = initialize_single_source($p_neighbours, $s, $p_distances, $p_predecessors );   
  my %Solved = ();
  my %Queue =  %$p_neighbours;

#  my $num = 48;
  while ( (scalar (keys %Queue) ) > 0  ) {
    my $u = extract_min(\%Queue, $p_distances, \%Solved );
    $Solved{ $u } ++;
    my @current_neighbours = split( /[\s\t\n]+/, $$p_neighbours{$u} );
    foreach my $v ( @current_neighbours  ) {
      if (! $p_weights ) {
        relax($u, $v, 1, $p_distances, $p_predecessors );
      }
    }
#    if ( ($num --) < 0 ) { return 0; }
  }

  return $flag;
}





############################################################
# Date:100802Tue	Author:Hong Qin
# Usage: $u = extract_min(\%Elements, \%values, \%Solved);    
# Description: 
#  Return the element whose $values{$element} is the smallest and $element is not in %Solved
#  This elements is removed from %Elements
#  Return NULL is failed
# Calls moran::min(@data);
# Tested in  test_dijkasta.pl   
# Used in ?

sub extract_min {
  use moran;
  use strict; use warnings; my $debug = 0;
  my ($p_hash, $p_values, $p_Solved ) = @_;
  
  my $min = max(values %$p_values); 
  foreach my $key ( keys %$p_hash ) {
    if ( ( $$p_values{ $key } <= $min ) and (!(exists $$p_Solved{$key})) ) {
      $min = $$p_values{ $key };
    }
  }

  foreach my $key ( keys %$p_hash ) { 
    if ( $$p_values{ $key } == $min ) {
      delete $$p_hash{ $key };
      if ($debug) {
      	print "(extract_min) [$key] is the closest node with distance [$min].\n"; 
        print "(extract_min) [$key] is removed from Queue\n";
      }
      return $key;
    }
  }

  return undef;
}




############################################################
# Date: 100802Tue	Author:Hong Qin
# Usage: $flag = relax($u, $v, $w, \%distances, \%predecessors );   
# Description: Relax the edge ($u,$v), testing whether we can improve
#  the shortest path to $v by going through $u
#  Return 1 if success, 0 if failed. 
# Calls ?
# Tested in  test_dijkasta.pl   
# Used in ?

sub relax {
  use strict; use warnings; my $debug = 0;
  my ($u, $v, $w, $p_distances, $p_predecessors) = @_;
  my $flag = 1;

  if ( $$p_distances{$v} > ( $$p_distances{$u} + $w ) ) {
    $$p_distances{$v} = $$p_distances{$u} + $w ;
    $$p_predecessors{$v} = $u;
    if ($debug) { 
       print "(relax) \$p_distances[$v] is updated to [$$p_distances{$v}]\n"; 
       print "(relax) \$p_predecessors[$v] is updated to [$u]\n";
    }
  }

  return $flag;
}




############################################################
# Date:100802Tue	Author:Hong Qin
# Usage: $infinity_flag = initialize_single_source(\%neighbours, $source, \%distances, \%predecessors);         
# Description: initialization for single source shortest path search
#  return the infinity_flag if success, 0 if failed.   
# Calls ?
# Tested in  test_dijkasta.pl   
# Used in ?

sub initialize_single_source {
  use strict; use warnings; my $debug = 0;
  my ($p_neighbours, $s, $p_distances, $p_predecessors ) = @_;
  my $flag = 1;
  my @head_nodes = sort( keys %$p_neighbours );
  my $infinity = 4 * $#head_nodes;

  foreach my $key ( @head_nodes ) {
    $$p_distances{ $key } = $infinity;
    $$p_predecessors{ $key } = '';
  }
  $$p_distances{ $s } = 0;

  if ($debug>1) {
    print "(initialize_single_source) \$p_distances is:\n";
    showHashTable($p_distances);
    print "(initialize_single_source) \$p_predecessors is:\n";
    showHashTable($p_predecessors);
  }
  return $infinity;
}


##############################################################
1;

