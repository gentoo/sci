# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic multilib toolchain-funcs

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - elmerpost"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV%_p*}/${MY_PN}/?view=tar&pathrev=4651 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug opengl"

RDEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0=
	opengl? (
		virtual/opengl
		media-libs/ftgl
		)
	sci-libs/matc"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/post"

PATCHES=(
	"${FILESDIR}"/${P}-oof.patch
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-tcltk8.6.patch
	"${FILESDIR}"/${P}-bfr-overflow.patch
	"${FILESDIR}"/${P}-impl-dec.patch
)

src_prepare() {
	use opengl && append-cppflags $($(tc-getPKG_CONFIG) --cflags ftgl)
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_with debug)
		--with-matc
		--with-x
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install ELMER_POST_DATADIR="/usr/share/elmerpost"
}
