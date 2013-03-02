############################################################
# Subroutines for taxonomy analysis
# Hong Qin
#
#   use lib '/shar/lib/perl/';     use Taxonomy
############################################################


############################################################
# Date:093003	Author: Hong Qin
# Usage: $taxid   = species2taxid($species)
# Usage: $species = taxid2speices($taxid)
# Usage: %species2taxid = get_species2taxid_hash();
# Usage: %taxid2species = get_taxid2species_hash();
# Description: ftp://www.ncbi.hlm.nih.gov/Taxonomy/taxonomyhome.html/
# Calls ?
# Tested in taxid.pl   
# Used in ?

sub _ncbi_taxid_species_string {
 my $string ="3702    Arabidopsis thaliana
9913    Bos taurus
6239    Caenorhabditis elegans
7955    Danio rerio
7227    Drosophila melanogaster
9606    Homo sapiens
4513    Hordeum vulgare
4081    Lycopersicon esculentum
3880    Medicago truncatula
10090   Mus musculus
4530    Oryza sativa
10116   Rattus norvegicus
9823    Sus scrofa
4565    Triticum aestivum
8355    Xenopus laevis
4577    Zea mays";
 return $string;
}

sub get_taxid2species_hash {
 use strict; use warnings; my $debug = 0;
 my $string = _ncbi_taxid_species_string;
 my @lines = split ( /\n/, $string );
 my @tokens = ();
 foreach my $line (@lines) {
  my @els = split ( /\s+/, $line);
  my $first = shift @els;
  my $rest = join ( ' ', @els);
  push (@tokens, $first, $rest);
 }

 my %taxid2species = ();
 for ( my $i=0; $i<=$#tokens; $i= $i + 2 ) {
   $taxid2species{ $tokens[$i] + 0 } = $tokens[$i+1] ;
   if ($debug) {   print "$tokens[$i+1]\t$tokens[$i]\n";  }
 }
 
 return %taxid2species;

}

sub get_species2taxid_hash {
 use strict; use warnings; my $debug = 0;
 my $string = _ncbi_taxid_species_string; 
 
 my @lines = split ( /\n/, $string );
 my @tokens = ();
 foreach my $line (@lines) {
  my @els = split ( /\s+/, $line);
  my $first = shift @els;
  my $rest = join ( ' ', @els);
  push (@tokens, $first, $rest);
 }

 my %species2taxid = ();
 for ( my $i=0; $i<=$#tokens; $i= $i + 2 ) {
   $species2taxid{ $tokens[$i+1] } = $tokens[$i] + 0 ;
   if ($debug) {   print "$tokens[$i+1]\t$tokens[$i]\n";  }
 }

 return %species2taxid;
}

# Usage: $taxid   = species2taxid($species)
sub species2taxid {
 my %species2taxid = get_species2taxid_hash(); 
 #use Util; showHashTable(\%species2taxid);
 return $species2taxid{$_[0]};
}

# Usage: $species = taxid2speices($taxid)
sub taxid2speices {
 my %taxid2species =  get_taxid2species_hash();      
 return $taxid2species{$_[0]};
}





 
############################################################
# Usage:        if (  hit_hyperthermo_bac ( @hit1, $hit2, ... ... ) eq 'YES' )

sub hit_hyperthermo_bac {
 use strict; use warnings; my $debug = 0;
  my $hyperthermo_bac = "Aae Tma";
  my @hits = @_;        my ( $element, $hit ) = ();
  my @hyperthermo_bac = split ( /\s+/,  $hyperthermo_bac ) ;
  if ($debug) { foreach my $i ( 0..$#hyperthermo_bac ) { print "- $hyperthermo_bac[$i]-"; } print "\n"; }
 
  foreach $element ( @hyperthermo_bac ) {
        foreach $hit ( @hits ) {
                if ( $hit =~ / $element[: ]/ ) { return 'YES' }
        }
  }
  return 'NO';
}


############################################################
# Usage:        if (  hit_crenarchaeota( @hit1, $hit2, ... ... ) eq 'YES' )
# Tested in  taxonomy.pl       
 
sub  hit_crenarchaeota  {
  use strict; use warnings; my $debug = 0;
  my $crenarchaeota = "Ape aeP Sso Sto";
  my @hits = @_;        my ( $element, $hit ) = ();
  my @crenarchaeota = split ( /\s+/, $crenarchaeota ) ;
  if ($debug) { foreach my $i ( 0..$#crenarchaeota ) { print "-$crenarchaeota[$i]-"; } print "\n"; }
 
  foreach $element ( @crenarchaeota ) {
        foreach $hit ( @hits ) {
                if ( $hit =~ / $element[: ]/ ) { return 'YES' }
        }
  }
  return 'NO';
}

 
############################################################
# Usage:        if (  hit_euryarchaeota( @hit1, $hit2, ... ... ) eq 'YES' )

sub  hit_euryarchaeota  {
  use strict; use warnings; my $debug = 0;
  my $euryarchaeota = "Afu Hbs Mja Mth Tac Tvo Pho Pab";
  my @hits = @_;        my ( $element, $hit ) = ();
  my @euryarchaeota = split ( /\s+/, $euryarchaeota ) ;
  if ($debug) { foreach my $i ( 0..$#euryarchaeota ) { print "-$euryarchaeota[$i]-"; } print "\n"; }
 
  foreach $element ( @euryarchaeota ) {
        foreach $hit ( @hits ) {
                if ( $hit =~ /  $element[: ]/ ) { return 'YES' }
        }
  }
  return 'NO';
}


############################################################
# Usage: 	if ( hit_eubacteria_beta( @hit1, $hit2, ... ... ) eq "YES" ) 
# This does not consider Thermotoga and Aquifex
# tested in ?
# used in ?

sub hit_eubacteria_beta {
  use strict; use warnings; my $debug = 0;

  # 31 Species abbreviations
  my $eubacteria = "jHp Cje Mlo Ccr Rpr Ctr Cpn Tpa Bbu Uur Mpn Mge Dra Mtu Mle Lla 
   Spy Bsu Bha Syn Eco EcZ Buc Pae Vch Hin Pmu Xfa Nme NmA Hpy ";

  my @hits = @_; 	 my @eubacteria = split ( /\s+/, $eubacteria ) ;	  my ($element, $hit) = ();

  if ($debug) { foreach my $i ( 0..$#eubacteria ) { print "-$eubacteria[$i]-"; } print "\n"; }
  foreach $element ( @eubacteria ) {
	foreach $hit ( @hits ) { 
	 	if ( $hit =~ / $element[: ]/ ) { return 'YES' }
	}
  }
  return 'NO'; 
}


# end of the module

1;

