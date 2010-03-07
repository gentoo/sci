# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# inherit

REL="06March09"
MY_P="${PN}${PV}"

DESCRIPTION="Program for processing of non-uniformly sampled (NUS) multidimensional NMR spectra"
HOMEPAGE="www.nmr.gu.se/~mdd/"
SRC_URI="http://www.nmr.gu.se/~mdd/Downloads/${MY_P}_${REL}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="mddnmr"
IUSE=""

RDEPEND="sci-chemistry/nmrpipe"
DEPEND=""

S="${WORKDIR}"/${MY_P}

src_install() {
	exeinto /opt/${PN}/com
	doexe com/* || die

	exeinto /opt/${PN}/bin
	if use amd64; then
		doexe binLinux64/* || die
	elif use x86; then
		doexe binLinux32/* || die
	fi

	cat >> "${T}"/43mddnmr <<- EOF
	PATH="${EPREFIX}/opt/${PN}/com:${EPREFIX}/opt/${PN}/bin"
	MDD_NMR="/opt/${PN}"
	EOF

	doenvd "${T}"/43mddnmr

	dodoc Readme* || die
}
