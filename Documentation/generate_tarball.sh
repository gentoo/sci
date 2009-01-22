#!/usr/bin/env bash
## $Id: export-tarball 8916 2005-11-23 18:09:55Z korpela $
## Modified by scarabeus 2008-10-23
###############################################################################
# functions
###############################################################################
# print out help function
help() {
	echo "Welcome to Boinc tarball generator"
	echo
	echo "For correct usage set VERSION argument"
	echo "Example:"
	echo "$0 -v 6.1.1"
	exit 0
}
###############################################################################
# argument passing
###############################################################################
if [[ $1 == "--help" ]]; then
	help
fi
while getopts v: arg ; do
	case $arg in
		v) VERSION=${OPTARG};;
		*) help;;
	esac
done
if [ -z "${VERSION}" ]; then
	help
fi
###############################################################################
# variable definition
###############################################################################
SVN_URI="http://boinc.berkeley.edu/svn/tags/boinc_core_release_${VERSION//./_}"
PACKAGE="boinc-${VERSION}"
BUNDLE_PREFIX="boinc-dist"
LOG=linux.log
###############################################################################
# prepare enviroment
###############################################################################
mkdir ${BUNDLE_PREFIX} -p
rm -rf $PACKAGE/"${BUNDLE_PREFIX}"/* # CLEANUP
cd "${BUNDLE_PREFIX}"
touch "${LOG}"
echo "" > "${LOG}"	# LOG CLEANUP
###############################################################################
# get data from svn
###############################################################################
echo "<Downloading files from SVN repository>"
echo "<******************************>"
svn export ${SVN_URI} ${PACKAGE} >> "${LOG}"
###############################################################################
# cleanup files we fetched
###############################################################################
echo "<Cleaning up data we fetched>"
echo "<******************************>"
# we create tarball for linux so cleanup mess
# bundled zlib library
rm -rf $PACKAGE/zlib/
# bundled zip libs
rm -rf $PACKAGE/zip/zip/
rm -rf $PACKAGE/zip/unzip/
# bundled openssl stuff
rm -rf $PACKAGE/openssl/
# smash html
rm -rf $PACKAGE/html/
# bundled curl
rm -rf $PACKAGE/curl/
# other platforms stuff
rm -rf $PACKAGE/win_build/
rm -rf $PACKAGE/mac_{installer,build}/
rm -rf $PACKAGE/clientgui/{mac,msw}/
rm -rf $PACKAGE/client/{os2,win}/
rm -rf $PACKAGE/lib/mac/
# we never ever will do documentation stuff
rm -rf $PACKAGE/doc/

# fix search for unwanted stuff
sed -i \
	-e "s:win_build::g" \
	-e "s:doc::g" \
	$PACKAGE/Makefile.am
# reconfigure
# somebody who likes autotools will have to do this :D i have no clue there
#pushd "$PACKAGE"/
#AT_M4DIR="m4" autoconf && autoheader && automake
#popd
###############################################################################
# create tbz
###############################################################################
tar cjf "${PACKAGE}".tar.bz2 ${PACKAGE} >> "${LOG}"
find ./ -maxdepth 1 -type f -name \*.tar.bz2 -print | while read FILE ; do
	echo "FILE: ${FILE}"
	echo "      SIZE: $(`which du` -h ${FILE} |`which awk` -F' ' '{print $1}')"
	echo "    MD5SUM: $(`which md5sum` ${FILE} |`which awk` -F' ' '{print $1}')"
	echo "   SHA1SUM: $(`which sha1sum` ${FILE} |`which awk` -F' ' '{print $1}')"
	echo
done
echo "<<<All done>>>"
###############################################################################
