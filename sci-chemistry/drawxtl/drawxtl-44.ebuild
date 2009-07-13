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
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="examples fltk opengl"

DEPEND="opengl? (
		virtual/opengl
		virtual/glut
		)
	fltk? ( x11-libs/fltk:1.1[opengl?] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

PATCHES=(
	"${FILESDIR}"/${PV}-ldflags.patch
	)

src_prepare() {
	base_src_prepare
	cd "${S}"/source
	sed \
		-e 's:-g::g' \
		-e 's:-O2:${CFLAGS} `fltk-config --cxxflags`:g' \
		-e 's:-lfltk\b:`fltk-config --ldflags`:g' \
		-e 's:-lXinerama::g' \
		-e 's:^.SILENT::' \
		-i DRAWshell${PV}/Makefile || die "sed failed"
	sed \
		-e 's:-g -O :${CFLAGS} :g' \
		-e 's:/usr/local/include:/usr/include:g' \
		-e 's:/usr/local/lib:/usr/lib:g' \
		-e 's:^.SILENT::' \
		-i ${MY_P}/Makefile || die "sed failed"

	if ! use opengl; then
		sed -i -e 's:define OPENGL 1:undef OPENGL:' ${MY_P}/drawxtl.h || die "sed failed"
		sed -i -e 's:$(GLUTlopt)::g' ${MY_P}/Makefile || die "sed failed"
	fi
}

src_compile() {
	# that missing exe dir is required by the Makefile
	mkdir exe || die "mkdir failed"
	cd source/${MY_P}
	make clean || die
	emake \
		CXX=$(tc-getCXX) \
		CC=$(tc-getCC) \
		LINKopt="${LDFLAGS}" \
		|| die "Build of ${MY_PN} failed"

	if use fltk; then
		cd "${S}"/source/DRAWshell${PV}
		emake \
		CXX=$(tc-getCXX) \
		CC=$(tc-getCC) \
		LINKopt="${LDFLAGS}" \
		|| die "Build of DRAWshell failed"
	fi
}

src_install() {
	dobin exe/${MY_P} || die "dobin failed"

	if use fltk; then
		dobin exe/DRAWshell${PV} || die "dobin failed"
	fi

	dodoc docs/readme.txt || die "dodoc failed"
	insinto /usr/share/doc/${P}
	doins docs/*.pdf || die "doins failed"

	if use examples; then
		docinto examples
		dodoc examples/* || die "dodoc failed"
	fi
}

pkg_postinst() {
	einfo "If you use DRAWxtl for your publications you can cite it as:"
	einfo " Larry W. Finger, Martin Kroeker, and Brian H. Toby (2007):"
	einfo " DRAWxtl, an open-source computer program to produce crystal-structure drawings"
	einfo " J. Appl. Crystallogr. 40, 188-192"
}
