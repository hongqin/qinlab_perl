############################################################
# subroutines for bacillus coat protein analysis
# Hong Qin
# To use this module, put following lines
#  use lib '/home/hqin/lib/perl/'; 
# or BEGIN { unshift(@INC,"/home/hqin/lib/perl/");   }


############################################################

BEGIN { unshift(@INC,"/home/hqin/lib/perl/");   }

############################################################
# Date:042407       Author:Hong Qin
# Usage: $flag = set_coat_BG2name_hash( \%coat_BG2name);
# Description: lookup table, BG Id to coat gene names
# Calls   $flag = _set_coat_BG2namehash( \%coat_BG2name );
# Tested in t.coat.pl
# Used in ?

sub set_coat_BG2name_hash {
  use strict; use warnings; my $debug = 0;
  my ( $rh_BG2name ) = @_;
  my ( $flag, %h_BG2name) = ();

  $flag = _set_coat_BG2namehash( $rh_BG2name  );

  if ($debug) {
   print "Coat::set_coat_BG2name()";
   showHashTable( $rh_BG2name );
  }

  return 0;
}

############################################################
# Date:042407       Author:Hong Qin
# Usage: $flag = set_coat_Bsu2name_hash( \%coat_Bsu2name);
# Description: lookup table, BsuId to coat gene names
# Calls  $flag = _set_coat_Bsu2BG_hash( \%coat_Bsu2BG);
#	 $flag = _set_coat_BG2namehash( \%coat_BG2name );
# Tested in t.coat.pl
# Used in ?

sub set_coat_Bsu2name_hash {
  use strict; use warnings; my $debug = 0;
  my ( $rh_Bsu2name ) = @_;
  my ( $flag, %h_Bsu2BG, %h_BG2name) = ();

  $flag = _set_coat_Bsu2BG_hash( \%h_Bsu2BG);
  $flag = _set_coat_BG2namehash( \%h_BG2name );

  foreach my $Bsu (keys %h_Bsu2BG) {
    $rh_Bsu2name->{ $Bsu } = $h_BG2name{ $h_Bsu2BG{ $Bsu }  } ;
  }

  if ($debug) {
   print "Coat::set_coat_Bsu2name()";
   showHashTable( $rh_Bsu2name );
  }

  return 0;
}






############################################################
# Date:042407      Author:Hong Qin
# Usage: $flag = _set_coat_Bsu2BG_hash( \%coat_Bsu2BG);
# Description:  get pairs of coat protein in Bsu and BG format
# Calls none
# Tested in t.coat.pl
# Used in ?

sub _set_coat_Bsu2BG_hash {
  use strict; use warnings; my $debug = 0;
  my ( $rh_Bsu2BG ) = @_;

my $longline = "BG13088 Bsu1065 
BG10346 Bsu2807 
BG10490 Bsu0630 
BG10275 Bsu2279 
BG13036 Bsu0977 
BG12424 Bsu3449 
BG13506 Bsu1901 
BG12181 Bsu0571 
BG12236 Bsu0891 
BG11196 Bsu1975 
BG13318 Bsu1380 
BG13484 Bsu1866 
BG13781 Bsu2780 
BG10491 Bsu3603 
BG11381 Bsu3086 
BG12231 Bsu0879 
BG13035 Bsu0978 
BG11791 Bsu3604 
BG13821 Bsu3087 
BG11380 Bsu3085 
BG10347 Bsu2806 
BG14044 Bsu3224 
BG12251 Bsu1427 
BG12423 Bsu3450 
BG11194 Bsu1978 
BG11811 Bsu0892 
BG13097 Bsu1074 
BG10106 Bsu0043 
BG14013 Bsu3269 
BG11187 Bsu0362 
BG13104 Bsu1090 
BG10022 Bsu4060 
BG11197 Bsu1974 
BG10946 Bsu3122 
BG13153 Bsu1174 
BG11017 Bsu3605 
BG11801 Bsu0691 
BG10494 Bsu1704 
BG10608 Bsu3788 
BG10500 Bsu1177 
BG13288 Bsu1406 
BG10498 Bsu1176 
BG10012 Bsu4050 
BG13822 Bsu3088 
BG10499 Bsu1175 
BG13084 Bsu1061 
BG11382 Bsu3084 
BG12167 Bsu0555 
BG11172 Bsu0261 
BG12512 Bsu3619 
BG13180 Bsu1206 
BG11193 Bsu1977 
BG13356 Bsu1499 
BG11822 Bsu1798 
BG10496 Bsu1179 
BG11448 Bsu2225 
BG13415 Bsu1732 
BG14052 Bsu3168 
BG11881 Bsu3954 
BG11609 Bsu2198 
BG10492 Bsu1771 
BG12335 Bsu2828 
BG10495 Bsu1210 
BG10497 Bsu1178 
BG11195 Bsu1976 
BG11800 Bsu0690 
BG13471 Bsu1768 
BG11666 Bsu2509 
BG13537 Bsu1960 
BG11799 Bsu0689 
BG10493 Bsu2220 
BG10776 Bsu1582 
BG13000 Bsu0983";

  my @longtokens = split( /\n/, $longline );
  foreach my $longtk ( @longtokens ) {
    my ($BG, $Bsu, @rest)  = split( /\s+/, $longtk);
    $rh_Bsu2BG->{ $Bsu } = $BG;
  }

  if ($debug) {
   print "Coat::set_coat_Bsu2BG()";
   showHashTable( $rh_Bsu2BG );
  }

  return 0;
}


############################################################
# Date:042407	Author: Hong Qin
# Usage: $flag = _set_coat_BG2namehash( \%coat_BG2name );
# Description: 	BG id to gene names for coat proteins
# 		return 0 upon success
#		This is an internal function
# Calls: none
# Tested in t.coatpl
# Used in ?

sub  _set_coat_BG2namehash {
  use strict; use warnings; my $debug = 0;
  my ( $r_hash ) = @_;

 my $BG2name_line = "> BG11193 CgeA 
> BG11194 CgeB 
> BG11195 CgeC 
> BG11196 CgeD 
> BG11197 CgeE 
> BG10490 CotA 
> BG10491 CotB 
> BG10492 CotC 
> BG10493 CotD 
> BG10494 CotE 
> BG10012 CotF 
> BG11017 CotG 
> BG11791 CotH 
> BG13821 YtaA 
> BG11799 CotJA 
> BG11800 CotJB 
> BG11801 CotJC 
> BG11822 CotM 
> BG11666 YqfT 
> BG13153 YjbX 
> BG12167 CotP 
> BG12424 YvdP 
> BG12423 YvdO 
> BG11380 CotS 
> BG11381 CotSA 
> BG10495 CotT 
> BG13471 YnzH 
> BG10496 CotV 
> BG10497 CotW 
> BG10500 CotX 
> BG10498 CotY 
> BG10499 CotZ 
> BG11172 CwlJ 
> BG10608 YwdL 
> BG13484 YoaN 
> BG13781 SafA 
> BG10275 SpoIVA 
> BG10346 SpoVID 
> BG10776 SpoVM 
> BG10946 Tgl 
> BG13000 YhaX 
> BG11811 YhbB 
> BG13035 YheC 
> BG13036 YheD 
> BG13084 YhjR 
> BG13104 YisY 
> BG12251 YknT 
> BG13356 YlbD 
> BG13415 YmaG 
> BG11448 YppG 
> BG13537 YodI 
> BG12335 YsnD 
> BG11382 YtxO 
> BG14013 YusA 
> BG14044 YutH 
> BG10347 YsxE 
> BG14052 YuzC 
> BG11881 YxeE 
> BG10022 YybI 
> BG10106 YabG 
> BG11187 YckK 
> BG12181 YdhD 
> BG12231 YgaK 
> BG12236 YhbA 
> BG13088 YirY 
> BG13097 YisJ 
> BG13180 YjdH 
> BG13318 YkvP 
> BG13288 YkuD 
> BG13506 YobN 
> BG11609 YpeP 
> BG13822 YtaB 
> BG12512 YwqH"; 

  my @longtokens = split( /\n/, $BG2name_line);
  foreach my $longtk ( @longtokens ) {
    $longtk =~ s/^>\s+//o;
    my ($BG, $name, @rest)  = split( /\s+/, $longtk);
    $r_hash->{ $BG } = $name;
  }

  if ($debug) {
   print "Coat::set_coat_BG2namehash()";
   showHashTable( $r_hash );
  }

  return 0;
}






##############################################################
1;

