# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Combine results from external gene predictors into final gene models"
HOMEPAGE="https://www.cbcb.umd.edu/software/jigsaw"
SRC_URI="https://www.cbcb.umd.edu/software/jigsaw/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}/${PN}-${PV//m}"

src_compile() {
	cd src/main || die
	emake
	cd ../../lib/oc1
	emake
}

src_install() {
	cd src/main || die
	emake DESTDIR="${ED}" install
	cd ../../lib/oc1
	emake DESTDIR="${ED}" install
}
