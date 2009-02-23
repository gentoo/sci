# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs versionator

MY_P="CBFlib_${PV}"

DESCRIPTION="Library providing a simple mechanism for accessing CBF files and imgCIF files."
HOMEPAGE="http://www.bernstein-plus-sons.com/software/CBF/"
BASE_TEST_URI="http://arcib.dowling.edu/software/CBFlib/downloads/version_${PV}/"
SRC_URI="http://www.bernstein-plus-sons.com/software/${MY_P}.tar.gz
	 test? (
		${BASE_TEST_URI}/${MY_P}_Data_Files_Input.tar.gz
		${BASE_TEST_URI}/${MY_P}_Data_Files_Output.tar.gz
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}"
RESTRICT="mirror"
S="${WORKDIR}/${MY_P}"

src_unpack(){
	unpack ${A}
	cd "${S}"

	cp Makefile_LINUX Makefile

#	if [[ "$(gcc-major-version)$(gcc-minor-version)" -ge 42 ]] && ( use x86 || use amd64 ) ; then
	if version_is_at_least "4.2" "$(gcc-version)" && ( use x86 || use amd64 ) ; then
	sed -e "330,375s:^CFLAGS.*$:CFLAGS  = ${CFLAGS} -ansi -D_POSIX_SOURCE:g" \
	    -e "330,375s:^F90FLAGS.*$:F90FLAGS = ${FFLAGS} -fno-range-check:g" \
	    -i Makefile
	else
	sed -e "330,375s:^F90LDFLAGS.*$:F90LDFLAGS = -bind_at_load:g" \
	    -i Makefile
	fi

	append-flags -fno-strength-reduce

	sed -e "1,50s:^CFLAGS.*$:CFLAGS  = ${CFLAGS}:g" \
	    -i getopt-1.1.4_cbf/Makefile

	epatch "${FILESDIR}"/HOMEDIR.patch

	if use test; then
		epatch "${FILESDIR}"/bzip-test.patch
	fi
}

src_compile(){
	emake -j1 \
	CC="$(tc-getCC)" \
	LDFLAGS=${LDFLAGS} \
	all
}

src_test(){
	emake -j1 tests
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}

