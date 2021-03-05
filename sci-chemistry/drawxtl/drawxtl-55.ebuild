# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PN="DRAWxtl"
MY_P=${MY_PN}${PV}

DESCRIPTION="Crystal structure drawings from structural data"
HOMEPAGE="http://www.lwfinger.net/drawxtl/"
SRC_URI="http://www.lwfinger.com/drawxtl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="5"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

DEPEND="
	virtual/opengl
	>=media-libs/freeglut-2.6
	virtual/opengl
	x11-libs/fltk:1[opengl]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
)

src_compile() {
	cd source/${MY_P} || die
	emake \
		CXX=$(tc-getCXX) \
		CXXFLAGS="${CXXFLAGS}"
}

src_install() {
	dobin exe/${MY_P}

	dodoc docs/readme.txt
	dodoc docs/*.pdf

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
