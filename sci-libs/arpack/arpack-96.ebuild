# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs fortran


DESCRIPTION="Library to solve large scale eigenvalue problems."
HOMEPAGE="http://www.caam.rice.edu/software/ARPACK"
# not a very good name: patch.tar.gz :(
SRC_URI="http://www.caam.rice.edu/software/ARPACK/SRC/${PN}${PV}.tar.gz
		 http://www.caam.rice.edu/software/ARPACK/SRC/patch.tar.gz
		 mpi? http://www.caam.rice.edu/software/ARPACK/SRC/p${PN}${PV}.tar.gz
		 mpi? http://www.caam.rice.edu/software/ARPACK/SRC/ppatch.tar.gz"

LICENSE="BSD"
SLOT="0"
IUSE="mpi examples"
KEYWORDS="~amd64 ~x86"
DEPEND="virtual/libc
mpi? ( virtual/mpi )"

# lapack USE/dependence not implemented because README file strongly
# recommands using arpack internal lapack (unless is lapack-2,
# which does not exist on gentoo).
# anyway, I could not run examples with the installed lapack-3 on my system

# mpi use is experimental

S=${WORKDIR}/ARPACK

src_compile() {

	emake \
		home=${S} \
		FC=${FORTRANC} \
		AR=$(tc-getAR) \
		RANLIB=$(tc-getRANLIB) \
		FFLAGS="${FFLAGS}" \
		MAKE=$(which make) \
		ARPACKLIB=${S}/libarpack.a \
		PRECISIONS="single double complex complex16 sdrv ddrv cdrv zdrv" \
		all || die "emake failed"

	# todo: make shared libraries
}

src_install() {
	dolib.a libarpack.a

	dodoc -README
	docinto DOCUMENTS
	dodoc DOCUMENTS/*

	if use examples; then
		for mkfile in $(ls -d EXAMPLES/*/makefile); do
			sed -e '/^include/d' \
				-e '1i ALIBS=-larpack' \
				-i ${mkfile}
		done
		insinto /usr/share/doc/${P}
		doins -r EXAMPLES
		if use mpi; then
			for mkfile in $(ls -d PARPACK/EXAMPLES/*/makefile); do
				sed -e '/^include/d' \
					-e 's:_\$(PLAT)::g' \
					-e '1i PLIBS=-lparpack' \
					-e '2i PFC=mpif77' \
					-e '3i PFFLAGS=${FFLAGS}' \
					-i ${mkfile}
			done
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