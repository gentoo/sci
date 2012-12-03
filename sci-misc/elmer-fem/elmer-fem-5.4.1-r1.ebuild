# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools eutils

ELMER_ROOT="elmerfem"
MY_PN=${PN/elmer-/}

DESCRIPTION="Elmer is a collection of finite element programs, libraries, and visualization tools, main fem"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI="http://elmerfem.svn.sourceforge.net/viewvc/${ELMER_ROOT}/release/${PV}/${MY_PN}/?view=tar -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="mpi debug"
DEPEND="sys-libs/glibc
	virtual/blas
	virtual/lapack
	sci-libs/arpack
	sci-libs/matc
	sci-libs/elmer-hutiter
	sci-libs/elmer-eio
	mpi?     ( sys-cluster/mpich2 )"
RDEPEND="${DEPEND}"
# Note this seems to only configure correctly with the elmer version of umfpack
# But this doesn't stop it from compiling / working without it

S="${WORKDIR}/${PV}/fem"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# configure must be executable
	chmod +x configure
	epatch ${FILESDIR}/elmer-fem-Makefile-install.patch
	eautoreconf
}

src_compile() {
	cd "${S}"
	local myconf
	export FC="gfortran"
	export F77="gfortran"
	myconf="$myconf --with-blas --with-lapack --with-arpack --with-huti"
	myconf="$myconf --with-eiof --with-matc"
	#TODO parpack support is not picked up from the arpack package
	#TODO --with-hypre --with-umfpack

	use mpi && myconf="$myconf --with-mpi --with-mpi-dir=/usr"
	use debug &&
		myconf="${myconf} --with-debug" ||
		myconf="${myconf} --without-debug"
	econf $myconf || die "econf failed"
	emake || die "emake failed"
}


src_install() {
	emake ELMER_SOLVER_DATADIR="${D}/usr/share/elmersolver"  DESTDIR="${D}" install || die "emake install failed"
}
