# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/libcmatrix/libcmatrix-3.11.0.ebuild,v 1.5 2012/12/27 18:30:44 jlec Exp $

EAPI="3"

inherit autotools eutils

MY_P="${PN}${PV}_lite"

DESCRIPTION="lite version of pNMRsim"
HOMEPAGE="http://www.dur.ac.uk/paul.hodgkinson/pNMRsim/"
#SRC_URI="${HOMEPAGE}/${MY_P}.tar.gz"
SRC_URI="http://dev.gentoo.org/~jlec/distfiles/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="sse threads"

RDEPEND="
	sci-libs/atlas[lapack]
	sci-libs/minuit"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}R3

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-shared.patch \
		"${FILESDIR}"/3.2.1-minuit2.patch \
		"${FILESDIR}"/3.2.1-gcc4.4.patch \
		"${FILESDIR}"/3.2.1-gcc4.6.patch \
		"${FILESDIR}"/3.2.1-gcc4.7.patch \
		"${FILESDIR}"/3.9.0-atlas.patch
	eautoreconf
}

src_configure() {
	econf \
		--with-minuit \
		--with-atlas \
		--with-sysroot="${EROOT}" \
		$(use_with sse) \
		$(use_with threads)
}

src_install() {
	dolib.so lib/*.so* || die "install failed"

	insinto /usr/include/${PN}R3
	doins include/* || die "no includes"

	dodoc CHANGES docs/* || die "no docs"
}
