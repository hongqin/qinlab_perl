#030503Wed v0.0
# source('ncp.r');

# 
# layout _ matrix(c (0.1, 0.75, 0.05, 0.95,
#                    0.85, 0.9, 0.05, 1,
#                    ),
#                 nrow=2, ncol=4, byrow=T);
# close.screen(all=T );
# split.screen(figs=layout);  

 tb _ read.table("ncp.dat", header=T, sep=",", fill=T); 

 s _ summary(tb); 


# k.d1 _ f.tb$k.000001;   f.d1 _ f.tb$f.000001;   ntot.d1  _ sum(f.d1, na.rm=T); 
# k.d3 _ f.tb$k.000011;   f.d3 _ f.tb$f.000011;   ntot.d3  _ sum(f.d3, na.rm=T); 
# k.d63 _ f.tb$k.111111;  f.d63 _ f.tb$f.111111;  ntot.d63 _ sum(f.d63,  na.rm=T); 

# lnk.d1  _ log(k.d1 );  lnk.d3  _ log(k.d3 );  lnk.d63 _ log(k.d63);
# p.d1   _ f.d1  / ntot.d1;  p.d3   _ f.d3  / ntot.d3;  p.d63  _ f.d63 / ntot.d63;
# lnp.d1  _ log(p.d1 );  lnp.d3  _ log(p.d3 );  lnp.d63 _ log(p.d63);

# m.d1 _ lm( lnp.d1 ~ lnk.d1 );
# gamma.d1 _ - m.d1$coefficients[2]; 

 screen(1);
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
