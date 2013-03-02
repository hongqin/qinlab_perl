############################################################
# Subroutines for Statistical analysis
# Initially written for Moran's I calculation
#
# Hong Qin
# To use this module, put following lines
#  use lib '/shar/lib/perl/';     use moran;
#
############################################################




#------------------------------end of unfinished business-----------------


############################################################
# Date:091702		Author:Hong Qin
# Usage: %freq = get_freq(\@data);
# Description: count the frequency of each number(symbol) in @data
# Note: @data can be either numbers or strings
# Used in  get_degree_by_category.pl   

sub get_freq {
  use strict; use warnings; my $debug = 1;
  my $ref_ar = $_[0];
  my %freq = ();

  foreach my $n ( @$ref_ar) {
    $freq{$n} ++;
  }
  return %freq;
}



############################################################
# Date: 082002Tue       Author: Hong Qin
# Usage: $occurence = occurence_of_less_or_equal_inputValue(\@data, $value);
# Description:
# Calls ?
# Tested in ?
# Used in cclu01

sub occurence_of_less_or_equal_inputValue {
  use strict; use warnings; my $debug = 1;
  my ($ref_array, $value) = @_;
  my $occurence = 0;
 
  foreach my $datum (@$ref_array) {
    if ($datum <= $value) {  $occurence ++; }
  }
  if ($debug) {
    print "(moran::less occurence) \$occurence =  $occurence\n";
  }
  return $occurence;
}


############################################################
# Date:	082002Tue	Author: Hong Qin
# Usage: $occurence = occurence_of_greater_or_equal_inputValue(\@data, $value);     
# Description:
# Calls ?
# Tested in ?
# Used in cclu01

sub occurence_of_greater_or_equal_inputValue {
  use strict; use warnings; my $debug = 1;
  my ($ref_array, $value) = @_;
  my $occurence = 0;

  foreach my $datum (@$ref_array) {
    if ($datum >= $value) {  $occurence ++; }
  }
  if ($debug) { 
    print "(moran::greater occurence) \$occurence =  $occurence\n";
  }
  return $occurence;
}


############################################################
# Author: "Mastering algorithms in perl"
#   Modified by Hong Qin
# Usage: $coviance = covariance(\@x, \@y)
# Used in "c2c2.2";
# Tested in ?
# Calls sub "mean()"

sub covariance {
 use strict; use warnings;
 my ($array1ref, $array2ref) = @_;
 my ($i, $result);

 if ( ( @$array1ref <=1 ) or ( @$array1ref <= 1))  { return 'ND' ; }

 for ($i=0; $i < @$array1ref; $i++) { 
    $result += $array1ref->[$i] * $array2ref->[$i];
 }
 $result /= @$array1ref;
 $result -= mean($array1ref) * mean($array2ref);
 return $result;
}



############################################################
# Author: "Mastering algorithms in perl"
#   Modified by Hong Qin
# Usage: $Pearson_R = correlation(\@x, \@y)
# Used in "c2c2.2"; 
# Call sub "covariance"
# Tested in ?

sub correlation {
 use strict; use warnings;
 my ($array1ref, $array2ref) = @_;  
 my ($sum1, $sum2);
 my ($sum1_squared, $sum2_squared);

 if ( ( @$array1ref <=1 ) or ( @$array2ref <= 1) ) { return 'ND'; }

 foreach (@$array1ref) { $sum1 += $_; $sum1_squared += $_ ** 2 }
 foreach (@$array2ref) { $sum2 += $_; $sum2_squared += $_ ** 2 }
 return (@$array1ref ** 2) * covariance($array1ref, $array2ref) /
   sqrt((( @$array1ref * $sum1_squared) - ($sum1 ** 2)) * 
	((@$array1ref * $sum2_squared) - ($sum2 ** 2)));
}



 
############################################################
# Author: "Mastering algorithms in perl"
#   Modified by Hong Qin
# Linear regression  y = a + b x
# Usage: ( $slope, $intercept ) = best_line(\@x, \@y)      
# Used in "c2c2.2"; returns the same slope as OpenOffice spreadsheet function SLOPE() does
# Tested in ?

sub  best_line {
 use strict; use warnings;
 my ($array1ref, $array2ref) = @_;
 my ($i, $product, $sum1, $sum2, $sum1_squares, $a, $b ) = ();

 if ( ( @$array1ref <=1 ) or ( @$array2ref <= 1) ) { return ('ND', 'ND') }

 for ($i=0; $i< @$array1ref; $i++) {
   $product += $array1ref->[$i] * $array2ref->[$i];
   $sum1 += $array1ref->[$i];
   $sum1_squares += $array1ref->[$i] ** 2;
   $sum2 += $array2ref->[$i];
 }
 $b = (( @$array1ref * $product) - ($sum1 * $sum2)) / (( @$array1ref * $sum1_squares) - ($sum1 ** 2));
 $a = ( $sum2 - $b * $sum1) / @$array1ref;
 return ( $b, $a);
}


 
############################################################
# Author: "Mastering algorithms in perl"
#	  Modified by Hong Qin
# Calculate the Gaussian significance

# Usage: $significance = gaussian1 ($value_of_interest, $mean, $variance )
#        $significance = gaussian2 ($value_of_interest, $mean, $std_dev )         

# used in gaussian.pl,  mode_of_codon_intragenic_position1.pl    

use constant two_pi_sqrt_inverse => 1 / sqrt(8 * atan2(1, 1) ); 

sub gaussian1 {
  use strict; use warnings;
  my ($x, $mean, $variance ) = @_;
  return two_pi_sqrt_inverse * 
   	exp( -( ($x - $mean) ** 2 ) / ( 2 * $variance ) ) / sqrt ($variance);
} 
  
sub gaussian2 {
  use strict; use warnings;
  my ($x, $mean, $stddev ) = @_;   
  return two_pi_sqrt_inverse *
        exp( -( ($x - $mean) ** 2 ) / ( 2 * $stddev * $stddev ) ) / $stddev;    
}

 


############################################################
# Author: "Mastering algorithms in perl"
 
# Usage: $min = min(@data) 
# Usage: $max = max(@data)
# Usage: @i_min = mini(\@data)
# Usage: @i_max = maxi(\@data)

# Tested in mergesort.pl

sub min { # Numbers
  my $min = shift;
  foreach ( @_ ) { $min = $_ if $_ < $min }
  return $min;
}

sub max { # Numbers
  my $max = shift;
  foreach ( @_ ) { $max = $_ if $_ > $max }
  return $max;
}

sub mini {
  my $l = $_[0];
  my $n = @{ $l };
  return () unless $n;  #Bail out if no list is given.
  my $v_min = $l->[0];  #initialize indices
  my @i_min = (0);

  for ( my $i =1; $i<$n; $i++ ) {
     if ( $l->[$i] < $v_min ) {
	$v_min = $l->[$i]; #update minimum and
	@i_min = ( $i); #reset indices
     } elsif ( $l->[$i] == $v_min ) {
	push @i_min, $i;  #accumulate minimum indice
     }
  }
  return @i_min;
}

sub maxi {
  my $l = $_[0];
  my $n = @{$l};
  return () unless $n; #bail out if no list is given.
  my $v_max = $l->[0]; #initialize indices
  my @i_max = (0);

  for ( my $i=1; $i<$n; $i++) {
      if ($l->[$i] > $v_max ) {
 	$v_max = $l->[$i]; #update maximum and
	@i_max = ($i); 	   #reset indices.
      } elsif ( $l->[$i] == $v_max ) {
	push @i_max, $i;   #accumulate maximum indices
      }
  }
  return @i_max;
}

 


############################################################
# Author: Hong Qin
# Usage: ( $y_string, $x_string) = histogram_2_xyStrings( \@histogram, "\t" );   
# Note: exclude bins without elements
# Tested in ?
# Used in "c2c2.2"

sub  histogram_2_xyStrings {
 use strict; use warnings;       my $debug = 1;
 my ( @data ) = @{$_[0]};
 my ( $deliminator ) = $_[1];
 my ( $y_string, $x_string ) = ( '', '');

 for ( my $i=0; $i<= $#data; $i++) {
  if ( $data[$i] > 0 ) {
    $y_string .= $data[ $i ] . $deliminator ;
    $x_string .= $i . $deliminator ;
  }
 }

 return ( $y_string, $x_string ) ;
}



############################################################
# Author: Hong Qin
# Warning:
# Note: Desinged for intergers data, such as connectivities
# Usage: @histograms = getHistogram_integer(\@integers, $step,$lowerBound, $upperBound )
# Calls mergesort_itr();
# Tested in ?
# Used in "c2c2.2"

sub  getHistogram_integer {
 use strict; use warnings;  	 my $debug = 0;
 my ( @data ) = @{$_[0]};
 my ( $step, $lowerBound, $upperBound) = ($_[1],$_[2], $_[3]) ;

 my ( @output, $i, $currentLimit, $bin_Num ) =();

 my $num_of_bins = ( $upperBound - $lowerBound + 1 ) / $step; # maybe only for debug

 mergesort_iter(\@data);  #first sort the data from smaller to larger

 # apply the upper and lower bounds
 while ( $data[0] < $lowerBound ) { shift @data; }
#  if ($debug) {print "(getHistogram)Data: @data\n"}
 while ( $data[ ( scalar @data ) -1  ] > $upperBound ) { pop @data; }
#  if ($debug) {print "(getHistogram)Data: @data\n"}

 foreach $i ( 0..$num_of_bins-1) { $output[$i]=0; }  # initiate the histogram    

 $currentLimit = $lowerBound ;  # The first step is made here
 $bin_Num = 0;
 foreach $i ( 0..@data-1 ) {
     if ($debug) {print "(getHistogram) currentLimit : $currentLimit  data[$i]: $data[$i] \n"}

     if ( $data[$i] > $currentLimit ) {  # for intergers only
         my $increment =  ($data[$i] - $currentLimit) ;
         $bin_Num +=  $increment ;  
         $currentLimit +=  $increment  ; 
      }

      $output[ $bin_Num ] ++;  # add one to the current bin

      if ( ($debug)&&( $bin_Num >=$num_of_bins ) ) {
         print "(getHistogram) Exceeds array upper bound!!!\n";  }
  }
  return @output;
}


 
############################################################
# Author: Hong Qin
# Warning: This only work on positive numbers!!!
#	   Can not correctly process the bounds of integer data.(use  getHistogram_integer)
# Usage: @histograms = getHistogram(\@data, $num_of_bins, $lowerBound, $upperBound )
# Calls mergesort_itr();
# Tested in mergesort.pl
# Used in ?

sub getHistogram {
  use strict; use warnings;
  my $debug = 1;
  my ( @data ) = @{$_[0]};     
  my ($num_of_bins, $lowerBound, $upperBound) = ($_[1],$_[2],$_[3]) ;
  my ( @output, $i, $currentLimit, $bin_Num ) =();           

  mergesort_iter(\@data);  #first sort the data from smaller to larger
  while ( $data[0] < $lowerBound ) { shift @data; }
#  if ($debug) {print "(getHistogram)Data: @data\n"}  
  while ( $data[ ( scalar @data ) -1  ] > $upperBound ) { pop @data; }
#  if ($debug) {print "(getHistogram)Data: @data\n"}  

  my $step = ($upperBound - $lowerBound ) / $num_of_bins;  # this is the range of the each bin

  foreach $i ( 0..$num_of_bins-1) { $output[$i]=0; }  # initiate the histogram

  $currentLimit = $lowerBound + $step;  # The first step is made here
  $bin_Num = 0;
  foreach $i ( 0..@data-1 ) {
     if ($debug) {print "(getHistogram) currentLimit : $currentLimit  data[$i]: $data[$i] \n"}      
     if ( $data[$i] > $currentLimit ) {  #This somehow only works for positive numbers???
         my $increment =  ($data[$i] - $currentLimit) / $step ;
	 if ( ($increment - int($increment)) !=0 ) { $increment += 1; }  #deal with the boundary values
	 $increment = int $increment;
         $bin_Num +=  $increment ;  # ???
         $currentLimit += $step * ( $increment ) ;  #   ???
      }
      $output[ $bin_Num ] ++;
      if ( ($debug)&&( $bin_Num >=$num_of_bins ) ) {
         print "(getHistogram) Exceeds array upper bound!!!\n";  }   
  }
  return @output;
}



############################################################
# Selection, percentile (), median()
# Find the median and percentile in an unsorted array
# From "Mastering algorithms with Perl
# Tested in test/mergesort.pl
#
# Usage:  ??

use constant PARTITION_SIZE => 5 ;

sub selection {
  my ( $array, $compare, $index ) = @_;
  my $N = @$array;

  return (sort { $compare->($a, $b) } @$array) [ $index-1 ] 
       if $N <= PARTITION_SIZE;

  my $medians;

  for ( my $i = 0; $i < $N; $i+= PARTITION_SIZE ) {
      my $s = $i + PARTITION_SIZE < $N ? PARTITION_SIZE : $N - $i;
      my @s = sort { $array->[ $i + $a ] cmp $array->[ $i + $b ] }
                   0 .. $s-1;
      push @{ $medians }, $array->[ $i + $s[ int( $s/2 ) ]];
  }

  my $median = selection ( $medians, $compare, int( @$medians/2) );
  my @kind;

  use constant LESS 	=> 0;
  use constant EQUAL	=> 1;
  use constant GREATER	=> 2;

  foreach my $elem ( @$array ) {
     push @{ $kind[$compare->($elem, $median) + 1] }, $elem;
  }

  return selection( $kind[LESS], $compare, $index ) if $index <= @{ $kind[LESS] };

  $index -= @{ $kind[LESS] };
  
  return $median if $index <= @{ $kind[EQUAL] };

  $index -= @{ $kind[EQUAL] };

  return selection( $kind[GREATER], $compare, $index );
}

sub median {
  my $array = shift;
  return selection( $array, 
                    sub { $_[0] <=> $_[1] },
                    @$array /2 +1 );
}

sub percentile {
  my ($array, $percentile) = @_;
  return selection ( $array,
		     sub { $_[0] <=> $_[1] },
		     ( @$array * $percentile) /100 );
}


############################################################
# Mergesort
# From "Mastering algorithms with Perl 
# Tested in test/mergesort.pl
# Usage: ?

my @work;  # A global array??

sub mergesort_iter ($) {
  my $debug = 1;
  use strict;

  my ( $array ) = @_;
  my $N = @$array;
  my $Nt2 = $N * 2; #N times 2.
  my $Nm1 = $N - 1; #N minus 1.

  $#work = $Nm1;

  for ( my $size = 2; $size < $Nt2; $size *=2 ) {
      for ( my $first = 0; $first < $N; $first += $size ) {
          my $last = $first + $size - 1 ;
          merge ( $array, $first, int(($first + $last) /2), 
                  $last < $N? $last : $Nm1 );
      }
  }
}


sub merge {
  my ( $array, $first, $middle, $last ) = @_;
  my $n = $last - $first + 1;

  for ( my $i = $first, my $j = 0; $i <= $last; ) {
      $work[ $j++ ] = $array->[ $i++ ];
  }

  $middle = int(($first + $last) /2 ) if $middle > $last;
 
  my $n1 = $middle - $first + 1;

  for ( my $i = $first, my $j =0, my $k = $n1; $i <= $last; $i++) {
      $array->[ $i ] =
          $j < $n1 &&
             ( $k == $n || $work[ $j ] < $work[ $k ] ) ?  # Change "lt" to "<" for numerical array
               $work[ $j++ ] :
               $work[ $k++ ];
  }
}





############################################################ 
# Dynamic implementation
# a different implementation of pseduoSignificance()

sub pseduoSignificance2 {
  use strict; use warnings;  my $debug = 1;
 
  my ( $range, $sampleSize, $meanInput, $bootstrapStep, $maxiBootStrap, $thresholdCount ) = @_;  #!!!

  if ( $debug) { print "(moran.pm) $range, $sampleSize, $meanInput, $bootstrapStep \n" ;}   

  my ( @randomSet ) = ();          my ( $i, $meanTmp ) = ();
  my ( $significantCount, $difference, $significance, $iterations ) = (0,0,0,0) ;
  srand (time ^ $$ ^ unpack "%32L*", 'ps axww|gzip'); 			# seed

  while ( ($significantCount< $thresholdCount) && ($iterations < $maxiBootStrap) ) { 
    for $i (1..$bootstrapStep) {
       $iterations ++ ;
       @randomSet = randomIntegerSet(1, $range, $sampleSize);        #start with 1
       $meanTmp = mean(\@randomSet);
       $meanTmp = $meanTmp/$range;
       $difference = abs($meanInput-0.5) - abs ($meanTmp-0.5);  # 0.5 is good  when $range is large
       if ($debug) { print "(moran.pm)$iterations: input $meanInput\trandom $meanTmp\tdiff $difference\n"  }   
       if ( $difference <= 0 ) {
          $significantCount ++;
          if ($debug) { print "(moran.pm) significantCount is incremented to $significantCount\n"  }
       }
    }
 }
 $significance =$significantCount/($iterations*2);  # one-tail estimation    
 return $significance ;
}
 
 
######################################################
#
# Usage $significance = pseduoSignificance($totalNum, $count, $mean, $bootstrap) ;
# Used in  pseudoSignifinaceOnCodonSpatialBias.pl

sub pseduoSignificance{
  use strict; use warnings;  my $debug = 1;
 
  my ( $range, $count, $meanInput, $bootstrap ) = @_;
  if ( $debug) { print "(moran.pm) $range, $count, $meanInput, $bootstrap \n" ;}
 
  my ( @randomSet ) = ();          my ( $i, $meanTmp ) = ();
  my ( $significantCount, $difference ) = (0,0) ;
  
  srand (time ^ $$ ^ unpack "%32L*", 'ps axww|gzip'); # seed

  for $i (1..$bootstrap) {
     @randomSet = randomIntegerSet(1, $range, $count);        #start with 1
     $meanTmp = mean(\@randomSet);
     $meanTmp = $meanTmp/$range;
     $difference = abs($meanInput-0.5) - abs ($meanTmp-0.5);  # 0.5 is good  when $range is large
     if ( $difference <= 0 ) { 
   	$significantCount ++;
        if ($debug) { print "(moran.pm) $significantCount is incremented to $significantCount\n"  }
     }
  }

  return $significantCount/($bootstrap*2);  # one-tail estimation
}


###################################################### 
# Return a set of randomly distributed intergers between bounds.  
# No duplicate in the returned set.
# The number of integers is specified by input.

# Usage @ar= randomIntegerSet( $lowerBound, $upperBound, $number_of_randomIntegers )

# Tested in testRandom.pl

# Must call srand before using this subroutine
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

sub randomIntegerSet {
  use strict; use warnings;  my $debug = 0;

  my ( $lowerBound, $upperBound, $number ) = @_;
  my ( $range ) = $upperBound - $lowerBound + 1;
  if ( $debug) { print " $lowerBound, $upperBound, $number, $range\n" ;}

  my ( @output, @flags ) = (); 	  	my ( $i, $next ) = ();

#  srand (time ^ $$ ^ unpack "%32L*", 'ps axww|gzip'); # seed

  foreach $i ( 0..$range-1 ) { $flags[$i]=0; }  # set the flags
  
  foreach $i ( 0..$number-1 ) {
    $next = int ( rand $range );
    while ( $flags[$next] == 1 ) {
      $next = int ( rand $range);
    }
    $output[$i] = $next + $lowerBound;
    $flags[$next] = 1;  # set the flags so that no redudancy occurs
  }
  
  return @output;
}



 
######################################################
# subroutine to round up a single value
# Usage $flag = round_hash(\%hash, $precision)

sub round_hash {
  my ( $p_hash ) = $_[0];     my ($p) = $_[1];
  my ($adjust) = 10**$p ;
 
  foreach my $key ( keys %$p_hash ) {
    $p_hash->{$key} = (int ($p_hash->{$key} * $adjust + 0.5) )/$adjust;
  }
  return 1;
}




 
######################################################
# subroutine to round up a single value
# Usage $return = round2($data, $precision)

sub round2 {
  my ( $input ) = $_[0];     my ($p) = $_[1];
  my ( $output ) =();           my ($adjust) = 10**$p ;
 
  $output =   (int  ($input * $adjust + 0.5 )) /$adjust;
  return $output;
}



######################################################
# subroutine to round up numbers in an array
# Usage @ar = round(\@data, $precision)

sub round {
  my ( @input ) = @{$_[0]};	my ($p) = $_[1];
  my ( @output ) =();		my ($adjust) = 10**$p ;

  foreach my $i(0..@input-1) {         
    $output[$i] =   (int  $input[$i] * $adjust)/$adjust;
  }
  return @output;
}



######################################################
# subroutine to calculate the sum of an array
# Usage $total = sum(\@data)

sub sum{
  my (@ar) = @{$_[0]};	my ($num, $i, $sum) = (0,0,0);
  $num = @ar;
  foreach $i(0..$num-1) {
    $sum += $ar[$i];
  }
  return $sum;
}


######################################################  
# Mean value of an array
# From "Mastering algorithms with Perl
# Usage: $mean = mean (\@array);

sub mean {
  use strict; use warnings;
  my $arrayref = shift;
  my $result;
  foreach my $element (@$arrayref) { $result += $element ;}
  if ( @$arrayref ==0 ) { return 0; }       #zero for an empty array 
  return $result/ @$arrayref;
}
 
 
###################################################### 
# Standard deviation of an array
# From "Mastering algorithms with Perl
# Usage: $sd = standard_deviation_data(\@array)

sub standard_deviation_data {
  my $arrayref = shift;
  my $mean = mean ($arrayref);
  return sqrt( mean ( [map $_ ** 2, @$arrayref]) - ($mean ** 2) );
}



######################################################
# subroutine to calculate the ratios by a $denominator
# Usage: @log_values = cal_log(\@data )
# Used in "c2c2.2"
 
sub cal_log {
  use strict; use warnings;
  my ( @input ) = @{$_[0]};
  my ( @output ) =();
 
  foreach my $i(0..@input-1) {
    $output[$i] = log $input[$i];
  }
  return @output; 
}


######################################################
# subroutine to calculate the ratios by a $denominator
# Usage: @ratios = cal_ratios(\@data, $denominator )
# Used in "c2c2.2"

sub cal_ratios{
  use strict; use warnings;
  my ( @input ) = @{$_[0]};     my ($denominator) = $_[1];
  my ( @output ) =();
 
  foreach my $i(0..@input-1) {
    $output[$i] = $input[$i] / $denominator;
  }
  return @output;
} 


#
#_____________Here starts Moran's I calculation subroutines_____________
#


######################################################
# subroutine to calculate the pseudo-number significance of Moran's I
# Usage: $significance = cal_sig_of_moranI(\@W, \@data, $num_of_permutation, $moranI, $repeat)

sub cal_sig_of_moranI{
 my ( @W ) = @{$_[0]};  my ( @data ) = @{$_[1]};
 my ( $num) = $_[2]; my ( $oldI ) = $_[3];
 my ( $repeat) = $_[4];
 my ( $newI, $max, $n , $count) = (0,0,0,0);  
 my ( @newdata ) =();

 $max = factorial(scalar(@data)) /2;
 $num = $num * $repeat;
 if ($max <= $num ) {
    print "(cal_sig_of_moranI) Reset to the  maximal number of permutations ($max).\n";
    $num = $max;
 }
 foreach $n (1..$num) {
   @newdata = permutate(\@data);   
   $newI = calculate_moranI_2(\@W, \@newdata);
   if ( $newI >= $oldI ) { $count++; };
 }
 return $count/$num; 	#the pseudo number significance   
}


######################################################
# subroutine to permutate an array
# Usage: @ar = permutate(\@data)
# Must call srand() before using this subroutine
# tested in testRandom.pl

sub permutate{
  use strict; use warnings;
  my ( @input ) = @{$_[0]};     
  my ( @output, @flags ) =();           my $num = scalar @input;
  my ( $i, $j, $next )=();  		my $debug = 0;

  foreach $i(0..$num-1) { $flags[$i] = 0; };

  foreach $i( 0..$num-1 ) {
    $next= int (rand $num);
    while ($flags[$next]) {
      $next= int (rand $num); 
    }
    if ($debug) { print "(moran:permutate) $next ";}
    $output[$i] = $input[$next];
    $flags[$next] =1;    
  }
  if ($debug) {print "\n";}
  return @output;
}



######################################################
#subroutine to calculate the difference
#Usage @diff = cal_diff(\@data, $mean)
sub cal_diff{
  my ( @input ) = @{$_[0]};	my ($m) = $_[1];
  my ( @output ) =();         
  
  foreach my $i(0..@input-1) {
    $output[$i] = $input[$i] - $m;
  }
  return @output;
}

######################################################
#subroutine to calculate the factorial
#Usage $result = factorial(100);
sub factorial {
  my ($n)= $_[0];	my $results=1;
  foreach my $i (1..$n) {
    $results = $results*$i;  	#  print "  $results   \t";
  }
  return $results;
}



######################################################
#subroutine to calculate Moran's I
# Usage:  $I = calculate_moranI_2(\@adj_matrix, \@data);
sub calculate_moranI_2 {
  my ( @W ) = @{$_[0]};         my ( @z ) = @{$_[1]};
  my ($Wzz, $zz, $ww, $I) = ();
  my ( $px, $py, $num) =();
  
  $num = @z;
  open (OUT, ">>test2_moran");
  foreach  $py(0..$num-1) {
    foreach  $px(0...$num-1) {    #      print $W[$py][$px]."\t";
      $Wzz += $W[$py][$px] * $z[$px] * $z[$py];
      $ww += $W[$py][$px] * $W[$py][$px];
    }#$px
  }#$py

  foreach $py(0..$num-1) {
    $zz  += $z[$py] * $z[$py];
  }

  print OUT  "\nww is : $ww \n";
  print OUT  "Wzz is: $Wzz \n";     print OUT  "zz  is: $zz \n";
  $I= ($Wzz/$ww)/($zz/$num);       print OUT  "I is:".$I."\n";          return $I;
  close (OUT);
}


1;
