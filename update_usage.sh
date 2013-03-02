for file in $( ls *.pm )
do
 alias=$( echo $file | cut -f 1 -d "." )
 echo "$alias"
 out= "_usage.$alias.txt"
 echo "$out"
 grep Usage $file > $out
done
exit

#grep "Usage" *.pm > 	_list
#grep "Usage" Align.pm > 	_align_list
#grep "Usage" BeginPerlBioinfo.pm > 	_beginperl_list
#grep "Usage" Codon.pm > 	_codon_list
#grep "Usage" Graph.pm > 	_graph_list
#grep "Usage" moran.pm > 	_moran_list
#grep "Usage:" Pajek.pm > 	_pajek_list
#grep "Usage:" Taxonomy.pm > 	_taxonomy_list
#grep "Usage:" Util.pm > 	_util_list
#grep "Usage:" Yeast.pm > 	_yeast_list

