
$seq1 = "ATG AUG TCG acg Atg tga";
$seq2 = "CTG taa act gaa aaa gtc";

print $seq1."\n";
print $seq2."\n";

print "----\n";

@triplets1 = split(/ /, $seq1);
print "@triplets1\n";


@triplets2 = split(/ /, $seq2);
print "@triplets2\n";

@tmp = @triplets2;
pop @tmp;
shift @tmp;
print "Origianal: @triplets2\n";
print "After pop and shift, the original are: @triplets2\n";
print "The new array are: @tmp\n";
