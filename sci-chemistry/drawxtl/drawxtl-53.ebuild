# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_PN="DRAWxtl"
MY_P=${MY_PN}${PV}
DESCRIPTION="This software can be used to produce crystal structure drawings from structural data"
HOMEPAGE="http://www.lwfinger.net/drawxtl/"
SRC_URI="http://home.att.net/~larry.finger/drawxtl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="virtual/opengl
	virtual/glut
	virtual/glu
	>=x11-libs/fltk-1.1.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"/source
	sed -i -e "s:-g:${CFLAGS} `fltk-config --cxxflags`:" -e "s:-lfltk\b:`fltk-config --ldflags`:g" \
		-e "s:-lXinerama::g" ${MY_P}/Makefile || die "sed failed"
	# the build system uses -DFREEGLUT24 if freeglut-2.4 is present. We will warn about that in pgk_postinst
	# see comment there
	if ! has_version "=media-libs/freeglut-2.4*"; then
		sed -i -e "s:-DFREEGLUT24::g"  ${MY_P}/Makefile || die "sed failed"
	fi
}

src_compile() {
	cd source/${MY_P}
	emake || die "Build of ${MY_PN} failed."
}

src_install() {
	dobin exe/${MY_P}

	dodoc docs/readme.txt
	insinto /usr/share/doc/${P}
	doins docs/*.pdf

	if use examples; then
		docinto examples
		dodoc examples/*
	fi
}

pkg_postinst() {
	# DRAWxtl works around some bug in freeglut-2.4. Unless we have more information, which versions are 
	# affected, I would like to keep it like this. 
	# A patch for DRAWxtl to add a runtime-check could be considered later.
	if has_version "=media-libs/freeglut-2.4*"; then
		elog
		elog "${MY_P} was build for beeing used with freeglut-2.4"
		elog "If you change to a different glut, you should rebuild ${MY_P}"
		elog
	else
		elog
		elog "If you change your glut library to freeglut-2.4, you will have to rebuild ${MY_P}"
		elog
	fi
}
