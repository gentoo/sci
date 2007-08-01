# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Library for parsing mathematical expressions"
HOMEPAGE="http://muparser.sourceforge.net/"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
MY_PN="${PN/P/p}"
MY_PV="v${PV/./}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}_${MY_PV}.tar.gz"

REDEPEND=""
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# fix destdir to install pkgconfig file
	epatch "${FILESDIR}"/${P}-destdir.patch
}

src_compile() {
	econf --disable-samples || die "econf failed"
	emake -j1 CXXFLAGS="${CXXFLAGS}"|| die "emake failed"
}

src_test() {
	econf --enable-samples || die "econf failed"
	emake || die "emake failed"
	echo "LD_LIBRARY_PATH=${PWD}/lib samples/example1/example1 << EOF" > test.sh
	echo "quit" >> test.sh
	echo "EOF" >> test.sh
	sh ./test.sh || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc Changes.txt  Credits.txt || die "dodoc failed"
	use doc && dohtml -r docs/html/*
}
