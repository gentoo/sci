# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs base

MY_PN="DRAWxtl"
MY_P=${MY_PN}${PV}

DESCRIPTION="This software can be used to produce crystal structure drawings from structural data"
HOMEPAGE="http://www.lwfinger.net/drawxtl/"
SRC_URI="http://home.att.net/~larry.finger/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="virtual/opengl
	virtual/glut
	virtual/glu
	x11-libs/fltk:1.1[opengl]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	)

src_prepare() {
	base_src_prepare
	sed  \
		-e 's:-g:${CFLAGS} `fltk-config --cxxflags`:' \
		-e 's:-lXinerama::g' \
		-e '52c\LINKFLTKGL=`fltk-config --ldflags` -lfltk_gl' \
		-e 's:^.SILENT::' \
		-i source/${MY_P}/Makefile || die "sed failed"
	# the build system uses -DFREEGLUT24 if freeglut-2.4 is present. We will warn about that in pgk_postinst
	# see comment there
	if ! has_version "=media-libs/freeglut-2.4*"; then
		sed -i -e "s:-DFREEGLUT24::g"  source/${MY_P}/Makefile || die "sed failed"
	fi
}

src_compile() {
	cd source/${MY_P}
	emake \
		CXX=$(tc-getCXX) \
		|| die "Build of ${MY_PN} failed"
}

src_install() {
	dobin exe/${MY_P} || die "dobin failed"

	dodoc docs/readme.txt || die "nothing to read"
	insinto /usr/share/doc/${P}
	doins docs/*.pdf || die "doins failed"

	if use examples; then
		docinto examples
		dodoc examples/* || die "dodoc failed"
	fi
}

pkg_postinst() {
	# DRAWxtl works around some bug in freeglut-2.4. Unless we have more information, which versions are
	# affected, I would like to keep it like this.
	# A patch for DRAWxtl to add a runtime-check could be considered later.
	if has_version "=media-libs/freeglut-2.4*"; then
		elog "${MY_P} was build for beeing used with freeglut-2.4"
		elog "If you change to a different glut, you should rebuild ${MY_P}"
	else
		elog "If you change your glut library to freeglut-2.4, you will have to rebuild ${MY_P}"
	fi
		einfo "If you use DRAWxtl for your publications you can cite it as:"
		einfo " Larry W. Finger, Martin Kroeker, and Brian H. Toby (2007):"
		einfo " DRAWxtl, an open-source computer program to produce crystal-structure drawings"
		einfo " J. Appl. Crystallogr. 40, 188-192"
}
