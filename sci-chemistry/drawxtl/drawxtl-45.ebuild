# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

MY_PN="DRAWxtl"
MY_P=${MY_PN}${PV}

DESCRIPTION="Crystal structure drawings from structural data"
HOMEPAGE="http://www.lwfinger.net/drawxtl/"
SRC_URI="http://www.lwfinger.com/drawxtl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="examples fltk opengl"

DEPEND="
	opengl? (
		virtual/opengl
		media-libs/freeglut
		)
	fltk? ( x11-libs/fltk:1[opengl?] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	cd "${S}"/source || die
	if ! use opengl; then
		sed -i -e 's:define OPENGL 1:undef OPENGL:' ${MY_P}/drawxtl.h || die "sed failed"
		sed -i -e 's:$(GLUTlopt)::g' ${MY_P}/Makefile || die "sed failed"
	fi

	tc-export CC CXX
}

src_compile() {
	# that missing exe dir is required by the Makefile
	mkdir exe || die "mkdir failed"
	cd source/${MY_P} || die
	emake clean
	default

	if use fltk; then
		cd "${S}"/source/DRAWshell${PV} || die
		default
	fi
}

src_install() {
	dobin exe/${MY_P}

	if use fltk; then
		dobin exe/DRAWshell${PV}
	fi

	dodoc docs/readme.txt
	insinto /usr/share/doc/${P}
	doins docs/*.pdf

	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	einfo "If you use DRAWxtl for your publications you can cite it as:"
	einfo " Larry W. Finger, Martin Kroeker, and Brian H. Toby (2007):"
	einfo " DRAWxtl, an open-source computer program to produce crystal-structure drawings"
	einfo " J. Appl. Crystallogr. 40, 188-192"
}
