#030503Wed v0.0
# source('ncp.r');

# generate the codon table

 tb <- read.table("2.dat", header=T, sep="\t"); 
 s <- summary(tb, na.rm=T); 
 ntot <- sum ( summary(tb$codon))   # total number of codons

 tb.fac <- levels( tb$codon );
 stats <- matrix( data=NA, nrow=length(tb.fac), ncol=4 );
 dimnames(stats) <- list( as.character(levels(tb$codon)), c("avg","std","median","peak") );

# avg.ncp <-  vector(mode = "numeric", length(tb.fac) ) ;
# names(avg.ncp) <- as.character( levels(tb$codon) ); 

 for ( f in tb.fac ) {
  tb.sub <- tb$ncp[ tb$codon == f ];
  # avg.ncp[ as.character(f) ]  <- mean(tb.sub);
  stats[ as.character(f), 'avg' ] <-  mean(tb.sub);  
  stats[ as.character(f), 'std' ] <-  sqrt( var(tb.sub) );  
  if( length(tb.sub) > 10 ) 
 	hist(tb.sub, main = paste("Histogram of", as.character(f)), prob=T,
	    	     xlab = "normalized codon position",
		     ylab = "probability"	
	) ;
 }
 
 stats;	



# 
# layout _ matrix(c (0.1, 0.75, 0.05, 0.95,
#                    0.85, 0.9, 0.05, 1,
#                    ),
#                 nrow=2, ncol=4, byrow=T);
# close.screen(all=T );
# split.screen(figs=layout);  

# plot(lnk.d1, lnp.d1, col="green", main="green-d1 blue-d3 red-d63' lm: ln(p)~ln(k)", 
# plot(lnk.d1, lnp.d1, col="green", xlab="logk", ylab="logP(k)");
# abline(m.d1, col="green");

# m.d3 _ lm( lnp.d3 ~ lnk.d3 );
# gamma.d3 _ - m.d3$coefficients[2];
# points(lnk.d3, lnp.d3, col="blue", pch=2);
# abline(m.d3, col="blue");

# m.d63 _ lm( lnp.d63 ~ lnk.d63 );
# gamma.d63 _ - m.d63$coefficients[2];
# points(lnk.d63, lnp.d63, col="red", pch=6);
# abline(m.d63, col="red");

# leg.txt _ c("d1","d3","d63");
# legend(3.2,-1,leg.txt, pch=c(1,2,6), col=c("green","blue","red") );

# screen(2);
# mtext( side=1, ad=1, line=4, "Fig 5");     


#q("no");

#first _ rep(0,279); second _ first; third _ first;                    	# manual check indices
#first[1:29] _ 1; second[94:136] _ 1; third[187:217] _ 1;		# manual check indices

#md     _ lm(log(pdall)~ logkall)
#md1363 _ lm(log(pdall)~ logkall +first +second +third);
#md1363whole _ lm(log(pdall)~ logkall*first +logkall*second +logkall*third);
 
# anova(md,md1363,md1363whole)    
# anova(md1363whole)  
# summary(md1363whole)      
# anova(md, md1363whole)
# summary(md)
