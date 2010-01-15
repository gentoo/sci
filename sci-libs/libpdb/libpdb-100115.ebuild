# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="PDB Record I/O Libraries -- c version"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.shar"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/sharutils"

S="${WORKDIR}"/${PN}

src_unpack() {
	/bin/sh "${DISTDIR}"/${A} || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		${PN}.a || die
}

src_install() {
	dolib.a ${PN}.a || die
	insinto /usr/include
	doins *.h || die
}
