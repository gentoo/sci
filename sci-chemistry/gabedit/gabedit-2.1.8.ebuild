# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit toolchain-funcs versionator

MY_PN=${PN/g/G}
MY_PV=$(delete_all_version_separators)
MY_P="${MY_PN}${MY_PV}Src"

DESCRIPTION="GUI for computational chemistry packages"
HOMEPAGE="http://gabedit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND=">=x11-libs/gtk+-2.4
	x11-libs/gtkglarea
	x11-libs/gl2ps
	virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"
S=${WORKDIR}/${MY_P}

src_prepare() {
	sed -i \
		-e "/GTK_DISABLE_DEPRECATED/s:define:undef:g" \
		"${S}/Config.h" \
		|| die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		COMMONCFLAGS="${CFLAGS}" \
		OGLLIB="-lGL -lGLU -lgtkgl-2.0 -lgl2ps" \
		OGLCFLAGS= \
		external_gtkglarea=1 \
		external_gl2ps=1 \
		|| die
}

src_install() {
	dobin ${PN} || die
	dodoc ChangeLog || die
}
