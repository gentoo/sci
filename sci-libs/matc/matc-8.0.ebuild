# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Finite element programs, libraries, and visualization tools - math C library"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="
	https://github.com/ElmerCSC/elmerfem/archive/release-${PV}.tar.gz -> ${P}.tar.gz
	doc? ( http://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf )"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug static-libs"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/elmerfem-release-${PV}/${PN}"

#PATCHES=( "${FILESDIR}"/${P}-shared.patch )

src_configure() {
	local myeconfargs=(
		$(use_with debug)
	)
	autotools-utils_src_configure
}

src_install() {
	use doc && DOCS=( "${DISTDIR}"/MATCManual.pdf )
	autotools-utils_src_install
}
