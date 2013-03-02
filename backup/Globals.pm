## Globals.pm - this file is created from Globals.txt
##
## $Id: Globals.txt 1339 2006-09-21 19:46:28Z tbailey $
##
## $Log$
## Revision 1.11  2005/10/25 21:25:20  nadya
## make LOGS/ location configurable during "configure" step
##
## Revision 1.10  2005/10/02 01:00:10  nadya
## move meme-client and mast-client names into Globals and use variables instead.
##
## Revision 1.9  2005/09/13 18:48:09  nadya
## clarify comment
##
## Revision 1.8  2005/08/24 05:42:07  nadya
## add variables from meme.cgi and mast.cgi
##
## Revision 1.7  2005/08/20 02:22:06  nadya
## fix typo
##
## Revision 1.6  2005/08/11 17:40:20  nadya
## add Exporter functionality
##
## Revision 1.5  2005/08/10 21:02:40  nadya
## mv MAXTIME to Globals module
##
## Revision 1.4  2005/08/07 06:20:31  nadya
## clean typos, rm debug
##
## Revision 1.3  2005/08/07 06:03:44  nadya
## add variables needed by cgi-scripts. Change SITE_CONTACT to
## SITE_MAINTAINER
##
## Revision 1.2  2005/08/06 01:23:09  nadya
## fix package name
##
## Revision 1.1.1.1  2005/07/31 20:37:51  nadya
## Importing from meme-3.0.14, and adding configure/make
##

# The following section sets site-specific global variables  
# that are set during running "configure"
#
# SITE_MAINTAINER - Contact person in case of trouble. The server will
#                   automatically send email to this address in case of error.
# SITE_URL        - URL of the server. 
# MEME_DlIR       - meme installation directory
# MEME_LOGS       - location of LOGS/
# MEME_BIN        - location of bin/
# MEME_WEB        - directory containing web-related files, default $MEME_DIR/web
# MAXTIME         - wall time limit for job to run
#

package Globals;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
         $SITE_MAINTAINER
         $SITE_URL
         $MEME_DIR
         $MEME_LOGS
         $MEME_BIN
         $MEME_WEB
         $MAXTIME
         $debug
         $MAX_UPLOAD_SIZE
         $MAXDATASET
         $MAXMOTIFS
         $MINW
         $MAXW
         $MINSITES
         $MAXSITES
         $MEME_CLIENT
         $MAST_CLIENT
	);

$SITE_MAINTAINER = "hqin@spirit";
$SITE_URL = "http://spirit/meme";
$MEME_DIR = "/home/hqin";
$MEME_LOGS = "/home/hqin/LOGS";
$MEME_BIN = "/home/hqin/bin";
$MEME_WEB = "/home/hqin/web";
$MAXTIME = "7200";
$MAST_CLIENT = "mast-client";
$MEME_CLIENT = "meme-client";


# turn on/off debug output
$debug = 0;

# maximum allowed sequence characters in upload file
$MAX_UPLOAD_SIZE = 1000000;	# note: change mast.html if you change this

# maximum size of training set
$MAXDATASET = 60000; 		

# this must be MAXG-1 in src/INCLUDE/user.h
$MAXMOTIFS = 100;		

$MINW = 2;
$MAXW = 300;
$MINSITES = 2;
$MAXSITES = 300;
