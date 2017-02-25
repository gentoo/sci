# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="Disequilibrium gene mapping based on coalescent theory using Bayesian MC methods"
HOMEPAGE="http://www.daimi.au.dk/~mailund/GeneRecon/"
SRC_URI="http://www.daimi.au.dk/~mailund/GeneRecon/download/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/popt
	dev-scheme/guile:12
	sci-libs/gsl"
DEPEND="${DEPEND}"

src_prepare() {
	sed 's|#PF#|'${PF}'|g' "${FILESDIR}"/${PN}-docfiles.patch > ${PN}-docfiles.patch

	epatch \
		${PN}-docfiles.patch \
		"${FILESDIR}"/${PV}-gcc4.patch \
		"${FILESDIR}"/${PV}-flags.patch
	eautoreconf
}
