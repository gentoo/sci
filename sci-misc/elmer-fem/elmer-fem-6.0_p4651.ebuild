# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true
FORTRAN_STANDARD=90

inherit autotools-utils fortran-2 multilib

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - main fem"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV%_p*}/${MY_PN}/?view=tar&pathrev=4651 -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi debug"

RDEPEND="
	virtual/blas
	virtual/lapack
	sci-libs/arpack
	sci-libs/matc
	sci-libs/elmer-hutiter
	sci-libs/elmer-eio
	mpi?     ( sys-cluster/mpich2 )"
DEPEND="${RDEPEND}"
# Note this seems to only configure correctly with the elmer version of umfpack
# But this doesn't stop it from compiling / working without it

S="${WORKDIR}/fem"

PATCHES=(
	"${FILESDIR}"/${P}-oos.patch
	"${FILESDIR}"/${P}-underlinking.patch
)

src_configure() {
	local myeconfargs=(
		$(use_with debug)
		$(usex mpi --with-mpi "")
		$(usex mpi --with-mpi-dir="${EPREFIX}"/usr "")
		--with-arpack="$($(tc-getPKG_CONFIG) --libs arpack)"
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)"
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
		--with-huti	--with-eiof --with-matc
	)
	autotools-utils_src_configure
}
