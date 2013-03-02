#! /usr/bin/perl -w
use strict;	use warnings;
use lib '/shar/lib/perl/';     use FASTA; use Codon;

my  $in = $ARGV[0];
my  $out = $ARGV[1];
my $Lc_mod3=0;
my $flag = get_LcMod3_records_in_paddled_fasta_file1( $in, $out, $Lc_mod3 ) ;   

exit;
$flag = get_ATG_records_in_paddled_fasta_file1($in, $out) ;

$flag = auto_detect_uniq_tokens_in_fasta_headers($in, "_fast_header.ctl");

my $seq = 'abc123efg4569';
print seq2delimited_triplets($seq);

 $flag = paddle_fasta_file1($in,$out);

open (IN, "<$out"); my @lines = <IN>; close (IN);
print @lines;

foreach my $i( 0..$#lines ) {
 print "(fasta.pl)$i $lines[$i]";
 my $triplet_string =  seq2delimited_triplets($lines[$i]);
 print "$triplet_string\n";
}


exit 1;

