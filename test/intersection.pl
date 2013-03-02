#! /usr/bin/perl -w

use lib '/shar/lib/perl/';     use Util;

 @Cats{ qw(cat lion tiger) } = ( 'mouse','sheep','zebra');
 @Asian{ qw(tiger panda yak) } = ( 'pig','bamboo','none'  );
 @Striped{ qw(zebra tiger) } = ( 'tiger','pig' );

$Cats_Asian_Striped = intersection( \%Cats, \%Asian, \%Striped );

print join(" ", keys %{ $Cats_Asian_Striped } ), "\n";
showHashTable($Cats_Asian_Striped);

%pairs = get_shared_pairs( \%Cats, \%Striped );    
 showHashTable(\%pairs);

exit;

