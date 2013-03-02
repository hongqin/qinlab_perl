#!/usr/bin/perl -w

$line = "hello [\"] world\n";
print $line;
@tokens = split ( /\"/, $line);
print "[@tokens]\n";
#end of main

