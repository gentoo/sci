# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="ksdssp is an open source implementation of dssp"
HOMEPAGE="http://www.cgl.ucsf.edu/Overview/software.html"
SRC_URI="http://www.cgl.ucsf.edu/Overview/ftp/${PN}.shar"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="as-is"
IUSE=""

RDEPEND="sci-libs/libpdb++"
DEPEND="
	${RDEPEND}
	app-arch/sharutils"

S="${WORKDIR}"/${PN}

src_unpack() {
	/bin/sh "${DISTDIR}"/${A}
}

src_compile() {
	emake \
		PDBINCDIR="${EPREFIX}/usr/include/libpdb++" \
		BINDIR="${EPREFIX}/usr/bin" \
		.TARGET="${PN}.csh" \
		.CURDIR="${S}" \
		CC="$(tc-getCXX)" \
		LINKER="$(tc-getCXX)" \
		OPT="${CXXFLAGS}" \
		LFLAGS="${LDFLAGS}" \
		${PN} ${PN}.csh || die
}

src_install() {
	dobin ${PN}{,.csh} || die
}
