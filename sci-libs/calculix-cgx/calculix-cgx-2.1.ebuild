# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils

MY_P=cgx_${PV}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="http://www.dhondt.de/${MY_P}.all.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.ps.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples nptl"

RDEPEND="media-libs/mesa[nptl=]
	>=media-libs/freeglut-1.0"
DEPEND="${RDEPEND}
	doc? ( app-text/ghostscript-gpl )"

S=${WORKDIR}/CalculiX/${MY_P}/src/

src_prepare() {
	epatch "${FILESDIR}"/01_${MY_P}_Makefile.patch
}

src_configure () {
	if use nptl; then
		export PTHREAD="-lpthread"
	else
		export PTHREAD=""
	fi
}

src_install () {
	dobin cgx

	if use doc; then
		cd "${WORKDIR}"
		ps2pdf ${MY_P}.ps ${MY_P}.pdf
		dodoc ${MY_P}.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/../examples/*
	fi
}
