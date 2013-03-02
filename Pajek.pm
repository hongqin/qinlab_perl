############################################################
# subroutines for converting text files into Pajek format
# Hong Qin
# To use this module, put following lines in Linux
#  use lib '/shar/lib/perl/';     use Pajek; 
#
############################################################



############################################################
# Date:	071002Wed	Author: Hong Qin
# Usage: @define_Pajek_colors = get_defined_Pajek_colors();
# Description: return the 78 defined colors in Pajek
# Tested in tp.pl 
# Used in 

sub  get_defined_Pajek_colors {
 use strict; use warnings; my $debug = 1;

 my $line_of_colors = "
 /GreenYellow   {0.15 0    0.69 0    }def
 /Yellow        {0    0    1    0    }def
 /Goldenrod     {0    0.10 0.84 0    }def
 /Dandelion     {0    0.29 0.84 0    }def
 /Apricot       {0    0.32 0.52 0    }def
 /Peach         {0    0.50 0.70 0    }def
 /Melon         {0    0.46 0.50 0    }def
 /YellowOrange  {0    0.42 1    0    }def
 /Orange        {0    0.61 0.87 0    }def
 /BurntOrange   {0    0.51 1    0    }def
 /Bittersweet   {0    0.75 1    0.24 }def
 /RedOrange     {0    0.77 0.87 0    }def
 /Mahogany      {0    0.85 0.87 0.35 }def
 /Maroon        {0    0.87 0.68 0.32 }def
 /BrickRed      {0    0.89 0.94 0.28 }def
 /Red           {0    1    1    0    }def
 /OrangeRed     {0    1    0.50 0    }def
 /RubineRed     {0    1    0.13 0    }def
 /WildStrawberry{0    0.96 0.39 0    }def
 /Salmon        {0    0.53 0.38 0    }def
 /CarnationPink {0    0.63 0    0    }def
 /Magenta       {0    1    0    0    }def
 /VioletRed     {0    0.81 0    0    }def
 /Rhodamine     {0    0.82 0    0    }def
 /Mulberry      {0.34 0.90 0    0.02 }def
 /RedViolet     {0.07 0.90 0    0.34 }def
 /Fuchsia       {0.47 0.91 0    0.08 }def
 /Lavender      {0    0.48 0    0    }def
 /Thistle       {0.12 0.59 0    0    }def
 /Orchid        {0.32 0.64 0    0    }def
 /DarkOrchid    {0.40 0.80 0.20 0    }def
 /Purple        {0.45 0.86 0    0    }def
 /Plum          {0.50 1    0    0    }def
 /Violet        {0.79 0.88 0    0    }def
 /RoyalPurple   {0.75 0.90 0    0    }def
 /BlueViolet    {0.86 0.91 0    0.04 }def
 /Periwinkle    {0.57 0.55 0    0    }def
 /CadetBlue     {0.62 0.57 0.23 0    }def
 /CornflowerBlue{0.65 0.13 0    0    }def
 /MidnightBlue  {0.98 0.13 0    0.43 }def
 /NavyBlue      {0.94 0.54 0    0    }def
 /RoyalBlue     {1    0.50 0    0    }def
 /Blue          {1    1    0    0    }def
 /Cerulean      {0.94 0.11 0    0    }def
 /Cyan          {1    0    0    0    }def
 /ProcessBlue   {0.96 0    0    0    }def
 /SkyBlue       {0.62 0    0.12 0    }def
 /Turquoise     {0.85 0    0.20 0    }def
 /TealBlue      {0.86 0    0.34 0.02 }def
 /Aquamarine    {0.82 0    0.30 0    }def
 /BlueGreen     {0.85 0    0.33 0    }def
 /Emerald       {1    0    0.50 0    }def
 /JungleGreen   {0.99 0    0.52 0    }def
 /SeaGreen      {0.69 0    0.50 0    }def
 /Green         {1    0    1    0    }def
 /ForestGreen   {0.91 0    0.88 0.12 }def
 /PineGreen     {0.92 0    0.59 0.25 }def
 /LimeGreen     {0.50 0    1    0    }def
 /YellowGreen   {0.44 0    0.74 0    }def
 /SpringGreen   {0.26 0    0.76 0    }def
 /OliveGreen    {0.64 0    0.95 0.40 }def
 /RawSienna     {0 0.72    1    0.45 }def
 /Sepia         {0 0.83    1    0.70 }def
 /Brown         {0 0.81    1    0.60 }def
 /Tan           {0.14 0.42 0.56 0    }def
 /Gray          {0    0    0    0.50 }def
 /Black         {0    0    0    1    }def
 /White         {0    0    0    0    }def
 /LightYellow   {0    0    0.4  0    }def
 /LightCyan     {0.2  0    0    0    }def
 /LightMagenta  {0    0.2  0    0    }def
 /LightPurple   {0.2  0.2  0    0    }def
 /LightGreen    {0.2  0    0.3  0    }def
 /LightOrange   {0    0.2  0.3  0    }def
 /Canary        {0    0    0.50 0    }def  
 /LFadedGreen   {0.10 0    0.20 0    }def
 /Pink          {0    0.15 0.05 0    }def  
 /LSkyBlue      {0.15 0.05 0    0    }def  ";

  my @lines = split ( /\//, $line_of_colors  );
    
  my ( @colors, @elements ) = ();
  foreach my $line ( @lines ) {
     @elements = split ( /[\s{]+/, $line );
     if ( defined $elements[0] ) {     push ( @colors, $elements[0] ); }
  } 

  return @colors;
}























##############################################################
1;

