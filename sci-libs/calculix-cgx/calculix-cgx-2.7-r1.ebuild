# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

MY_P=cgx_${PV}

DESCRIPTION="A Free Software Three-Dimensional Structural Finite Element Program"
HOMEPAGE="http://www.calculix.de/"
SRC_URI="http://www.dhondt.de/${MY_P}.all.tar.bz2
	doc? ( http://www.dhondt.de/${MY_P}.pdf )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# nptl removed since I cannot work around it
IUSE="doc examples"

RDEPEND="media-libs/mesa[nptl]
	>=media-libs/freeglut-1.0"
DEPEND="${RDEPEND}
	doc? ( app-text/ghostscript-gpl )"

S=${WORKDIR}/CalculiX/${MY_P}/src/

src_unpack() {
	default
	cp "${DISTDIR}/${MY_P}.pdf" "${S}"
}
src_prepare() {
	epatch "${FILESDIR}"/01_${MY_P}_Makefile_custom_cxx_flags.patch
	epatch "${FILESDIR}"/02_${MY_P}_menu_fix-freeglut_2.8.1.patch
}

src_configure () {
	# Does not compile without -lpthread
	#if use nptl; then
	export PTHREAD="-lpthread"
	#else
	#	export PTHREAD=""
	#fi
}

src_install () {
	dobin cgx

	if use doc; then
		dodoc ${MY_P}.pdf
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r "${S}"/../examples/*
	fi
}
