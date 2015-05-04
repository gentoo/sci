# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A package for generating the speeds, equilibrium arguments, and node factors of tidal constituents."
HOMEPAGE="http://www.flaterco.com/xtide/files.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND=">=sci-geosciences/libtcd-2.2.3"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
