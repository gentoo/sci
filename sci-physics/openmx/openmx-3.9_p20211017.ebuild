# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic fortran-2

DESCRIPTION="Material eXplorer"
HOMEPAGE="http://www.openmx-square.org/" # no https, SSL invalid
SRC_URI="
	http://t-ozaki.issp.u-tokyo.ac.jp/${PN}${PV//_*}.tar.gz
	http://www.openmx-square.org/bugfixed/21Oct17/patch${PV//_*}.9.tar.gz
"
S="${WORKDIR}/${PN}${PV//_*}/source"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

IUSE="debug openmp test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/blas
	virtual/lapack
	virtual/mpi
	sci-libs/scalapack
	sys-cluster/openmpi
	sci-libs/fftw:3.0[mpi,openmp?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

FORTRAN_STANDARD=90

pkg_setup() {
	# Link in the GNU Fortran library for Fortran code.
	# Other compilers may need other hacks.
	FC_LIB=""
	if [[ $(tc-getCC)$ == *gcc* ]]; then
		FC_LIB="-lgfortran"
	fi
	export FC_LIB

	export CC="mpicc"
	export FC="mpif90"

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

		rm "${code}."* || die
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

		rm "${code}."* || die
		popd

		if (( ${ret} )); then
			die "Please switch to an openmp compatible fortran compiler"
		else
			export FC="${FC} ${openmp}"
		fi
	fi

}

src_unpack() {
	unpack "${PN}${PV//_*}.tar.gz"
	# copy patched files to source
	cd "${S}" || die
	unpack "patch${PV//_*}.9.tar.gz"
}

src_configure() {
	local FFTW_FLAVOUR=fftw3
	if use openmp; then
	   FFTW_FLAVOUR=fftw3_omp
	   append-cflag -fopenmp
	else
	   append-cflag -Dnoomp
	fi
	append-cflag -Dkcomp
	append-cflag -ffast-math
	append-cflags $($(tc-getPKG_CONFIG) --cflags lapack)
	append-cflags $($(tc-getPKG_CONFIG) --cflags scalapack)
	append-cflags $($(tc-getPKG_CONFIG) --cflags openmpi)
	append-cflags $($(tc-getPKG_CONFIG) --cflags ${FFTW_FLAVOUR})

	append-fflags -I/usr/include
	append-fflags -Dkcomp
	append-fflags -ffast-math
	append-fflags $($(tc-getPKG_CONFIG) --cflags lapack)
	append-fflags $($(tc-getPKG_CONFIG) --cflags scalapack)
	append-fflags $($(tc-getPKG_CONFIG) --cflags openmpi)
	append-fflags $($(tc-getPKG_CONFIG) --cflags ${FFTW_FLAVOUR})

	# otherwise we get Error: Rank mismatch between actual argument
	# at (1) and actual argument at (2) (rank-1 and scalar)
	append-fflags -fallow-argument-mismatch

	local MX_LIB="$($(tc-getPKG_CONFIG) --static --libs lapack)"
	MX_LIB="${MX_LIB} $($(tc-getPKG_CONFIG) --static --libs scalapack)"
	MX_LIB="${MX_LIB} $($(tc-getPKG_CONFIG) --static --libs openmpi)"
	MX_LIB="${MX_LIB} $($(tc-getPKG_CONFIG) --static --libs ${FFTW_FLAVOUR})"
	MX_LIB="${MX_LIB} $(mpif90 -showme:link)"

	sed \
		-e "s%^CC *=.*$%CC  = ${CC} ${CFLAGS}%" \
		-e "s%^FC *=.*$%FC  = ${FC} ${FCFLAGS}%" \
		-e "s%^LIB *=.*$%LIB = ${MX_LIB} ${FC_LIB}%" \
		-i makefile || die
}

src_compile() {
	# does not properly parallelize
	# file 1 says can't find file 2
	# and at the same time file 2 can't find file 3
	emake -j1
}

src_test() {
	cd ../work || die
	../source/openmx -runtest || die
}

src_install() {
	insinto /usr/share/${P}
	doins -r DFT_DATA19
	cd ../work || die
	insinto /usr/share/${P}/examples
	doins -r *
	cd ../source || die
	emake DESTDIR="${D}/usr/bin" install
	dodoc "${S}/${PN}${PV%.?}.pdf"
	use test && dodoc "${S}"/work/runtest.result
}
