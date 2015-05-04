# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base toolchain-funcs

DESCRIPTION="Prediction of 1H, 13C and 15N chemical shifts for proteins"
HOMEPAGE="http://shiftx.wishartlab.com/"
SRC_URI="http://shiftx.wishartlab.com/download/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}

DEPEND=""
RDEPEND="sci-chemistry/shiftx2"

PATCHES=(
	"${FILESDIR}"/${PV}-Makefile.patch
	"${FILESDIR}"/${PV}-bfr-overflow.patch )

DOCS="README FEATURES *.pdb *.out"

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc ${DOCS}
}
