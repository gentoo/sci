# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Material eXplorer"
HOMEPAGE="http://www.openmx-square.org/"
SRC_URI="
	http://www.openmx-square.org/${PN}${PV}.tar.gz
	http://www.openmx-square.org/bugfixed/11Nov14/patch${PV}.1.tar.gz"

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

S="${WORKDIR}/${PN}${PV}"

pkg_setup() {
	if use mpi; then
		export CC="mpicc"
	else
		tc-export CC
	fi

	if use openmp; then
		if tc-has-openmp; then
			export CC="${CC} -fopenmp"
		else
			die "Please switch to an openmp compatible compiler"
		fi
	fi
}

src_prepare() {
	cd "${WORKDIR}"
	mv *.out "${PN}${PV}"/work/input_example
	mv *.[hc] "${PN}${PV}"/source
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

	local MX_LIB="$($(tc-getPKG_CONFIG) --static --libs lapack)"
	local MX_LIB="${MX_LIB} $($(tc-getPKG_CONFIG) --static --libs ${FFTW_FLAVOUR})"

	sed \
		-e "s%^CC *=.*$%CC  = ${CC} ${CFLAGS}%" \
		-e "s%^LIB *=.*$%LIB = ${MX_LIB}%" \
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
	doins -r DFT_DATA11
	cd work
	insinto /usr/share/${P}/examples
	doins -r *
	cd ../source
	dodir /usr/bin
	emake DESTDIR="${D}/usr/bin" install
	dodoc "${S}/${PN}${PV}.pdf"
	use test && dodoc "${S}"/work/runtest.result
}
