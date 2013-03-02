#! /usr/bin/perl -w

use strict;	use warnings;
use lib '/shar/lib/perl/';     use Align;      use Codon;    use Util; 

my $line = "0123456789";
my ( @dna) = (
"acctga",
"ttacaAa-tctcag---gggc---------------taa",
"aaaatgccgcgaatgaaaaacaagataatcccaccctgaaaaatgccgcgaatgaaaaacaagataatcccaccctag");


print $line."\n";
my $num = length($line);
print "length is $num\n";
print substr($line, $num-1, 1  );
print "\n";
print substr($line, $num-2 );
print "\n";
print substr($line, $num-3  );
print "\n";

print "@dna\n";
print  EndIsStopCodon($dna[0]);         
print "\n";
print  EndIsStopCodon($dna[1]);         
print "\n";
print  EndIsStopCodon($dna[2]);         
print "\n";

