# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

MY_P="${PN}${PV}_lite"

DESCRIPTION="lite version of pNMRsim"
HOMEPAGE="http://www.dur.ac.uk/paul.hodgkinson/pNMRsim/"
#SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="atlas threads"

RDEPEND="
	sci-libs/minuit
	atlas? ( sci-libs/blas-atlas )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}R3

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-minuit2.patch \
		"${FILESDIR}"/${PV}-gcc4.4.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-minuit \
		$(use_with atlas) \
		$(use_with threads)
}

src_install() {
	dolib.a lib/"${PN}".a || die "install failed"

	insinto /usr/include/${PN}R3
	doins include/* || die "no includes"

	dodoc CHANGES docs/* || die "no docs"
}
