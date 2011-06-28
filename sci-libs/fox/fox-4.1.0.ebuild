# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils

MY_PN="FoX"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A library designed to allow the easy use of XML from Fortran"
HOMEPAGE="http://www1.gly.bris.ac.uk/~walker/FoX/"
SRC_URI="http://www1.gly.bris.ac.uk/~walker/FoX/source/${MY_P}-full.tar.gz"

LICENSE="BSD ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc dom fast sax wcml wxml"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/4.0.4-install-customizations.patch
}

src_configure() {
		econf --prefix=/usr \
		$(use_enable debug) \
		$(use_enable dom) \
		$(use_enable fast) \
		$(use_enable sax) \
		$(use_enable wcml) \
		$(use_enable wxml) \
		FCFLAGS="${FCFLAGS:- ${FFLAGS:- -O2}}"
}

src_compile() {
	emake -j1 || die "make failed"
}

src_test() {
	emake -j1 check || die "make check failed"
	einfo "Please look at the last few RESULT lines for a summary."
}

src_install() {
	sed -i -e's%^comp_prefix=.*$%comp_prefix=/usr%' \
		-e's%comp_prefix/finclude%comp_prefix/lib/finclude%' \
		FoX-config
	emake -j1 DESTDIR="${D}" install || die "make install failed"
	dodoc README.FoX.txt Changelog || die "dodoc failed"
	if use doc; then
		dohtml -r DoX/ || die "installing the HTML docs failed"
	fi
}
