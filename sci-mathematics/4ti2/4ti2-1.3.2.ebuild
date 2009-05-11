# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="software package for algebraic, geometric and combinatorial problems"
HOMEPAGE="http://www.4ti2.de"
SRC_URI="http://4ti2.de/version_1.3.2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="sci-mathematics/glpk[gmp]
dev-libs/gmp[-nocxx]"

RDEPEND="${DEPEND}"

## This package seems to work with everything default

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}