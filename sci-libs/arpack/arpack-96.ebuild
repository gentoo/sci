# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils fortran


DESCRIPTION="Library to solve large scale eigenvalue problems."
HOMEPAGE="http://www.caam.rice.edu/software/ARPACK"
# not a very good name: patch.tar.gz :(
SRC_URI="http://www.caam.rice.edu/software/ARPACK/SRC/${PN}${PV}.tar.gz
		 http://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz
		 mpi? http://www.caam.rice.edu/software/ARPACK/SRC/p${PN}${PV}.tar.gz
		 mpi? http://www.caam.rice.edu/software/ARPACK/SRC/ppatch.tar.gz"

LICENSE="BSD"
SLOT="0"
# lapack USE/dependence not implemented. 
# README file strongly recommands using arpack 
# internal lapack
IUSE="blas mpi examples"
KEYWORDS="~amd64 ~x86"
DEPEND="virtual/libc
	>=sys-devel/libtool-1.5
	blas? ( virtual/blas )
	blas? ( sci-libs/blas-config )
	mpi? ( virtual/mpi )"

S=${WORKDIR}/ARPACK

src_compile() {
	cp -f "${FILESDIR}"/ARmake.inc ${S}
	RPATH="${DESTTREE}"/$(get_libdir)

	if use blas; then
		sed -i \
			-e "s:BLASLIB=:BLASLIB=$(blas-config --f77libs):" \
			-e "s:\$\(BLASdir\)::" \
			ARmake.inc || die "sed failed"
	fi

	emake \
		FC="libtool --mode=compile --tag=F77 ${FORTRANC}" \
		PFC="libtool --mode=compile --tag=F77 mpif77" \
		FFLAGS="${FFLAGS}" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		PRECISIONS="single double complex complex16 sdrv ddrv cdrv zdrv" \
		ARPACKLIB="${S}/libarpack.la" \
		PARPACKLIB="${S}/libparpack.la" \
		all || die "emake failed"

	libtool --mode=link --tag=CC ${FORTRANC} ${FFLAGS} -o libarpack.la */*.lo \
		-rpath ${RPATH} || die "libtool failed"
	if use mpi; then
		libtool --mode=link --tag=CC mpif77 ${FFLAGS} \
			-o libparpack.la */*.lo -rpath ${RPATH} || die "libtool failed"
	fi
}

src_install() {
	dodir ${RPATH}
	libtool --mode=install install -s libarpack.la \
		${D}/${RPATH} || die "libtool failed"
	if use mpi; then
		libtool --mode=install install -s libparpack.la \
			${D}/${RPATH} || die "libtool failed"
	fi
	dodoc README
	docinto DOCUMENTS
	dodoc DOCUMENTS/*

	if use examples; then
		insinto /usr/share/doc/${P}
		doins ARmake.inc
		doins -r EXAMPLES
		if use mpi; then
			insinto /usr/share/doc/${P}/PARPACK
			doins -r PARPACK/EXAMPLES
		fi
	fi
}

src_postinst() {
	einfo
	einfo "ARPACK has been compiled with internal LAPACK routines"
	einfo "\"LDFLAGS=-llarpack\" is enough to link your applications"
	einfo
}
