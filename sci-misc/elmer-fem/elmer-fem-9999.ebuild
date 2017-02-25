# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true
FORTRAN_STANDARD=90

inherit autotools-utils fortran-2 multilib subversion

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Finite element programs, libraries, and visualization tools - main fem"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI=""
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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
	"${FILESDIR}"/${PN}-6.0_p4651-oos.patch
	"${FILESDIR}"/${PN}-6.0_p4651-underlinking.patch
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
