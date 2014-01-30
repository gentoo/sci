# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils subversion

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - math C library"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="doc? ( http://www.nic.funet.fi/pub/sci/physics/elmer/doc/MATCManual.pdf )"
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc debug static-libs"

RDEPEND="
	sys-libs/ncurses
	sys-libs/readline"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

PATCHES=( "${FILESDIR}"/${PN}-6.0_p4651-shared.patch )

src_prepare() {
	subversion_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-shared
		$(use_with debug)
	)
	autotools-utils_src_configure
}

src_install() {
	use doc && DOCS=( "${DISTDIR}"/MATCManual.pdf )
	autotools-utils_src_install
}
