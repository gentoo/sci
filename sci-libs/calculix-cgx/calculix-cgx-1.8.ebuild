# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=cgx_${PV}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="http://www.dhondt.de/${MY_P}.all.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.ps.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND="doc? ( virtual/ghostscript )
	>=virtual/glut-1.0"

S=${WORKDIR}/CalculiX

src_unpack() {
	unpack ${A}

	epatch "${FILESDIR}"/01_${MY_P}_Makefile.patch
}

src_compile () {
	if built_with_use media-libs/mesa nptl; then
		export PTHREAD="-lpthread"
	else
		export PTHREAD=""
	fi

	cd ${MY_P}/src/
	emake || die "emake failed"
}

src_install () {
	cd ${MY_P}/src/
	dobin cgx || die "dobin failed"

	if use doc; then
		insinto /usr/share/doc/${PF}
		cd "${WORKDIR}"
		ps2pdf ${MY_P}.ps ${MY_P}.pdf
		doins ${MY_P}.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/${MY_P}/examples/*
	fi
}
