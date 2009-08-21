# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic toolchain-funcs

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

	epatch "${FILESDIR}"/Makefile.patch
}

src_compile(){
	append-fflags -fno-range-check

	emake -j1 \
	CC="$(tc-getCC)" \
	C++="$(tc-getCXX)" \
	F90C="$(tc-getFC)" \
	F90FLAGS="${FFLAGS}" \
	LDFLAGS="${LDFLAGS}" all || \
	die "make failed"
}

src_test(){
	emake -j1 tests || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
}
