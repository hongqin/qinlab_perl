rm Rplots.ps
R --no-save < $1
gv Rplots.ps &
