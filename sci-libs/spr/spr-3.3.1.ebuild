# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

MYP=SPR-${PV}

DESCRIPTION="Statistical analysis and machine learning library"
HOMEPAGE="http://www.hep.caltech.edu/~narsky/spr.html"
SRC_URI="mirror://sourceforge/statpatrec/${MYP}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="root"

DEPEND="root? ( sci-physics/root )"

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-autotools.patch
	rm -f aclocal.m4
	eautoreconf
	cp data/gauss* src/
}

src_configure() {
	econf $(use_with root)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README ChangeLog AUTHORS
}
