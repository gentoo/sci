# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="DRAWxtl"
MY_P=${MY_PN}${PV}
DESCRIPTION="This software can be used to produce crystal structure drawings from structural data"
HOMEPAGE="http://www.lwfinger.net/drawxtl/"
SRC_URI="http://home.att.net/~larry.finger/drawxtl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="examples fltk opengl"

DEPEND="opengl? (
		virtual/opengl
		virtual/glut
		)
	fltk? ( >=x11-libs/fltk-1.1.6 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"/source
	sed -i -e 's:-g::g' -e "s:-O2:${CFLAGS} `fltk-config --cxxflags`:g" -e "s:-lfltk\b:`fltk-config --ldflags`:g" \
		-e "s:-lXinerama::g" DRAWshell${PV}/Makefile || die "sed failed"
	sed -i -e "s:-g -O :${CFLAGS} :g" -e 's:/usr/local/include:/usr/include:g' -e 's:/usr/local/lib:/usr/lib:g' \
		${MY_P}/Makefile || die "sed failed"

	if ! use opengl; then
		sed -i -e 's:define OPENGL 1:undef OPENGL:' ${MY_P}/drawxtl.h
		sed -i -e 's:$(GLUTlopt)::g' ${MY_P}/Makefile
		# next lines are probably not needed after DRAWxtl43
		sed -i -e '56a\#ifdef OPENGL' -e '6007a\#endif' ${MY_P}/gl2ps.c
		sed -i -e '111a\#ifdef OPENGL' -e '112a\#endif' ${MY_P}/DRAWxtl1.c
	fi
}

src_compile() {
	cd source/${MY_P}
	emake || die "Build of ${MY_PN} failed."

	if use fltk; then
		cd "${S}"/source/DRAWshell${PV}
		emake || die "Build of DRAWshell failed."
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
