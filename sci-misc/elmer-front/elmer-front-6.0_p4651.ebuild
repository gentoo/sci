# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils multilib

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - elmer frontend"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV%_p*}/${MY_PN}/?view=tar&pathrev=4651 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/tcl:0=
	dev-lang/tk:0=
	sci-libs/matc
	sci-libs/elmer-eio
	virtual/opengl"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/front/front

PATCHES=(
	"${FILESDIR}"/${P}-tcltk8.6.patch
	"${FILESDIR}"/${P}-underlinking.patch
	"${FILESDIR}"/${P}-out-of-source.patch
)

src_configure() {
	local myeconfargs=(
		--with-eioc --with-matc --with-tcltk --with-x
	)
	autotools-utils_src_configure
}
