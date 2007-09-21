# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools eutils

MY_PN=CXSparse
DESCRIPTION="Extended sparse matrix package."
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/cxsparse"
SRC_URI="http://www.cise.ufl.edu/research/sparse/${MY_PN}/${MY_PN}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sci-libs/ufconfig"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-autotools.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README.txt Doc/ChangeLog || die "dodoc failed"
}
