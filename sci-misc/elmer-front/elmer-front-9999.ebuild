# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib subversion

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - elmer frontend"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI=""
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0=
	sci-libs/matc
	sci-libs/elmer-eio
	virtual/opengl"
DEPEND="${RDEPEND}"

S="${WORKDIR}/front"

PATCHES=(
	"${FILESDIR}"/${PN}-6.0_p4651-tcltk8.6.patch
	"${FILESDIR}"/${PN}-6.0_p4651-underlinking.patch
	"${FILESDIR}"/${PN}-6.0_p4651-out-of-source.patch
)

src_prepare() {
	subversion_src_prepare
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--with-eioc --with-matc --with-tcltk --with-x
	)
	autotools-utils_src_configure
}
