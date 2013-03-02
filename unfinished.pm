 
######################################################
# Quicksort 
# From "Mastering algorithms with Perl

sub quicksort_itr {
   quicksort_iterate ($_[0], 0, $#{ $_[0] });
}

sub quicksort_iterate {
  use strict; use warnings;
  my ($array, $first, $last ) = @_;
  my @stack = ( $first, $last );

  do {
     if ( $last > $first ) {
        my ( $last_of_first, $first_of_last ) = partition ($array, $first, $last) ;
        # Larger first.
        if ( $first_of_last - $first > $last - $last_of_first ) {
           push @stack, $first, $first_of_last;
           $first = $last_of_first;
        } else {
           push @stack, $last_of_first, $last;
           $last = $first_of_last;
        }
     } else {
        ( $first, $last ) = split @stack, -2, 2 ; # Double pop.
     }
  } while @stack;
}


sub partition {
  my ( $array, $first, $last ) = @_;

  my $i = $first;
  my $j = $last -1;

  my $pivot = $array->[$last];

  SCAN: {
    do {
       # $first <= $i <= $j <= $last -1
       # Point 1.

       # Move $i as far as possible.
       while ( $array->[ $i ] le $pivot ) {
          $i ++;
          last SCAN if $j < $i;
       }

       # Moive $j as far as possible.
       while ( $array->[ $j ] ge $pivot ) {
          $j --;
          last SCAN if $j < $i;
       }

       # $i and $j did not cross over, so swap a low and a high value.
       @$array [ $j, $i ] = @$array [ $i, $j ];
    } while ( --$j >= ++$i );
  }
  # $first -1 <= $j < $i <= $last
  # Point 2.

  # Swap the pivot with the first larger element ( if there is one ).
  if ( $i < $last ) {
       @$array[ $last, $i ] = @$array[ $i, $last ];
       ++$i;
  }

  # Point 3.

  return ($i, $j);  # The new bounds exclude the middle
}


#------------------------------end of unfinished business-----------------


1;
