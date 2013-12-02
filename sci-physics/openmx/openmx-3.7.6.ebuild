# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils multilib toolchain-funcs fortran-2

PATCHDATE="13Sep01"

DESCRIPTION="Material eXplorer using DFT, NC pseudopotentials, and pseudo-atomic localized basis functions"
HOMEPAGE="http://www.openmx-square.org/"
SRC_URI="
	http://www.openmx-square.org/${PN}${PV%.[0-9]}.tar.gz
	http://www.openmx-square.org/bugfixed/${PATCHDATE}/patch${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-debug mpi openmp test"

RDEPEND="
	virtual/blas
	virtual/lapack
	sci-libs/fftw:3.0[mpi?,openmp?]
	mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}${PV%.[0-9]}"

MAKEOPTS+=" -j1"

FORTRAN_STANDARD=90

pkg_setup() {
	# Link in the GNU Fortran library for Fortran code.
	# Other compilers may need other hacks.
	FC_LIB=""
	if [[ $(tc-getCC)$ == *gcc* ]]; then
		FC_LIB="-lgfortran"
	fi
	export FC_LIB

	if use mpi; then
		export CC="mpicc"
		export FC="mpif90"
	else
		tc-export CC
		tc-export FC
	fi

	if use openmp; then FORTRAN_NEED_OPENMP=1; fi

	fortran-2_pkg_setup

	if use openmp; then
		# based on _fortran-has-openmp() of fortran-2.eclass
		local code=ebuild-openmp-flags
		local ret
		local openmp

		pushd "${T}"
		cat <<- EOF > "${code}.c"
		# include <omp.h>
		main () {
			int nthreads;
			nthreads=omp_get_num_threads();
		}
		EOF

		for openmp in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
			${CC} ${openmp} "${code}.c" -o "${code}.o" &>> "${T}"/_c_compile_test.log
			ret=$?
			(( ${ret} )) || break
		done

		rm -f "${code}.*"
		popd

		if (( ${ret} )); then
			die "Please switch to an openmp compatible C compiler"
		else
			export CC="${CC} ${openmp}"
		fi

		pushd "${T}"
		cat <<- EOF > "${code}.f"
		1     call omp_get_num_threads
		2     end
		EOF

		for openmp in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp; do
			${FC} ${openmp} "${code}.f" -o "${code}.o" &>> "${T}"/_f_compile_test.log
			ret=$?
			(( ${ret} )) || break
		done

		rm -f "${code}.*"
		popd

		if (( ${ret} )); then
			die "Please switch to an openmp compatible fortran compiler"
		else
			export FC="${FC} ${openmp}"
		fi
	fi

}

src_prepare() {
	cd "${WORKDIR}"
	mv *.[hc] "${S}"/source
	epatch "${FILESDIR}/3.7-fortran_objects.patch"
}

src_configure() {
	local FFTW_FLAVOUR=fftw3
	if use openmp; then
	   FFTW_FLAVOUR=fftw3_omp
	else
	   export CFLAGS="${CFLAGS} -Dnoomp"
	fi
	if use mpi; then
	   FFTW_FLAVOUR=fftw3_mpi
	else
	   export CFLAGS="${CFLAGS} -Dnompi"
	fi
	CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) --cflags lapack)"
	CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) --cflags ${FFTW_FLAVOUR})"
	export CFLAGS

	FCFLAGS="${FCFLAGS} -I/usr/include"
	FCFLAGS="${FCFLAGS} $($(tc-getPKG_CONFIG) --cflags lapack)"
	FCFLAGS="${FCFLAGS} $($(tc-getPKG_CONFIG) --cflags ${FFTW_FLAVOUR})"
	export FCFLAGS

	local MX_LIB="$($(tc-getPKG_CONFIG) --static --libs lapack)"
	MX_LIB="${MX_LIB} $($(tc-getPKG_CONFIG) --static --libs ${FFTW_FLAVOUR})"
	if use mpi; then
		MX_LIB="${MX_LIB} $(mpif90 -showme:link)"
	fi

	sed \
		-e "s%^CC *=.*$%CC  = ${CC} ${CFLAGS}%" \
		-e "s%^FC *=.*$%FC  = ${FC} ${FCFLAGS}%" \
		-e "s%^LIB *=.*$%LIB = ${MX_LIB} ${FC_LIB}%" \
		-i source/makefile || die
}

src_compile() {
	emake -C source
}

src_test() {
	cd work
	../source/openmx -runtest || die
}

src_install() {
	insinto /usr/share/${P}
	doins -r DFT_DATA13
	cd work
	insinto /usr/share/${P}/examples
	doins -r *
	cd ../source
	dodir /usr/bin
	emake DESTDIR="${D}/usr/bin" install
	dodoc "${S}/${PN}${PV%.?}.pdf"
	use test && dodoc "${S}"/work/runtest.result
}
