# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A linkage disequilibrium association mapping tool"
HOMEPAGE="http://www.daimi.au.dk/~mailund/Blossoc/"
SRC_URI="http://www.daimi.au.dk/~mailund/Blossoc/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND="sci-libs/gsl"
RDEPEND="${DEPEND}"

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
}
