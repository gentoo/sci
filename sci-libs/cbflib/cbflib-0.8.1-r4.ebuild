# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils flag-o-matic toolchain-funcs base

MY_P1="CBFlib-${PV}"
MY_P2="CBFlib_${PV}"

DESCRIPTION="Library providing a simple mechanism for accessing CBF files and imgCIF files."
HOMEPAGE="http://www.bernstein-plus-sons.com/software/CBF/"
BASE_TEST_URI="http://arcib.dowling.edu/software/CBFlib/downloads/version_${PV}/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P1}.tar.gz
	 test? (
		${BASE_TEST_URI}/${MY_P2}_Data_Files_Input.tar.gz
		${BASE_TEST_URI}/${MY_P2}_Data_Files_Output.tar.gz
	)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RESTRICT="mirror"

S="${WORKDIR}/${MY_P1}"

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.patch
	)

src_prepare(){
	cp Makefile_LINUX_gcc42 Makefile

	base_src_prepare

	append-fflags -fno-range-check
	append-cflags -D_USE_XOPEN_EXTENDED

	sed \
		-e "s:^CC.*$:CC = $(tc-getCC):" \
		-e "s:^C++.*$:C++ = $(tc-getCXX):" \
		-e "s:C++:CXX:g" \
		-e "s:^CFLAGS.*$:CFLAGS = ${CFLAGS} -fPIC:" \
		-e "s:^F90C.*$:F90C = $(tc-getFC):" \
		-e "s:^F90FLAGS.*$:F90FLAGS = ${FFLAGS} -fPIC:" \
		-e "s:^DOWNLOAD.*$:LDFLAGS = ${LDFLAGS} -fPIC:" \
		-e "s:^SOLDFLAGS.*$:SOLDFLAGS = -shared:g" \
		-e "s: /bin: ${EPREFIX}/bin:g" \
		-e "s:/usr:${EPREFIX}/usr:g" \
		-i Makefile || \
		die "make failed"
}

src_compile() {
	emake -j1 all || die
}

src_test(){
	emake -j1 tests || die "test failed"
}

src_install() {
	use prefix || ED="${D}"
	emake INSTALLDIR="${ED}/usr" install || die "Install failed"

	# Install all what emake missed
	dolib.a lib/libfcb.a || die
	dolib.so solib/* || die
}
