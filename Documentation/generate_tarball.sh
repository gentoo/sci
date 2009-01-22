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
	echo "./script -v 6.1.1"
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
BUNDLE_PREFIX="${HOME}"/"${PACKAGE}"
LOG="${BUNDLE_PREFIX}"/linux.log
###############################################################################
# prepare enviroment
###############################################################################
mkdir -p "${BUNDLE_PREFIX}"
rm -rf "${BUNDLE_PREFIX}"/* # CLEANUP
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
# define release
sed -i '/#define\ BOINC_PRERELEASE\ 1/ c\//#define\ BOINC_PRERELEASE\ 0' \
	${PACKAGE}/version.h.in >> "${LOG}"
# remove windows stuff (we create tarball for gentoo)
rm -rf ${PACKAGE}/client/os2 ${PACKAGE}/client/win
rm -rf ${PACKAGE}/clientgui/mac ${PACKAGE}/clientgui/msw
rm -rf ${PACKAGE}/clientlib/
rm -rf ${PACKAGE}/lib/mac/
rm -rf ${PACKAGE}/mac_build/
rm -rf ${PACKAGE}/mac_installer/
rm -rf ${PACKAGE}/openssl/
rm -rf ${PACKAGE}/win_build/
rm -rf ${PACKAGE}/zlib/
rm -rf ${PACKAGE}/RSAEuro/
rm -rf ${PACKAGE}/stripchart/
rm -rf ${PACKAGE}/html/
# fixup build system
sed -i \
	-e "s:win_build::g" \
	-e "s:doc::g" \
	${PACKAGE}/Makefile.am
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
