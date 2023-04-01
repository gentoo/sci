# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="5eafea4328f1631eab28b1a20e757d1f0e21f8a6"
PYTHON_COMPAT=( python3_{10..11} )

inherit cmake flag-o-matic fortran-2 python-single-r1

DESCRIPTION="Arnoldi package library to solve large scale eigenvalue problems"
HOMEPAGE="
	https://www.caam.rice.edu/software/ARPACK/
	https://github.com/opencollab/arpack-ng
"
SRC_URI="
	https://github.com/opencollab/${PN}-ng/archive/${COMMIT}.tar.gz -> ${PF}.gh.tar.gz
	doc? (
		http://www.caam.rice.edu/software/ARPACK/SRC/ug.ps.gz -> ${PN}-ug.ps.gz
		http://www.caam.rice.edu/software/ARPACK/DOCS/tutorial.ps.gz -> ${PN}-tutorial.ps.gz
	)
"
S="${WORKDIR}/${PN}-ng-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc examples icb icbexmm int64 mpi python"

RDEPEND="
	virtual/blas
	virtual/lapack

	icbexmm? ( dev-cpp/eigen )
	mpi? ( virtual/mpi[fortran] )
	icb? ( virtual/mpi[cxx] )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-libs/boost:=[numpy,python,${PYTHON_USEDEP}]')
	)
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

REQUIRED_USE="
	icb? ( mpi )
	python? (
		${PYTHON_REQUIRED_USE}
		icbexmm
	)
"

src_configure() {
	append-fflags '-fallow-argument-mismatch'

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DEXAMPLES=$(usex examples)
		-DICB=$(usex icb)
		-DICBEXMM=$(usex icbexmm)
		-DINTERFACE64=$(usex int64)
		-DMPI=$(usex mpi)
		-DPYTHON3=$(usex python)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	dodoc DOCUMENTS/*.doc
	newdoc DOCUMENTS/README README.doc
	use doc && dodoc "${WORKDIR}"/*.ps
	if use examples; then
		for i in BAND COMPLEX NONSYM SIMPLE SVD SYM ; do
			exeinto "/usr/libexec/${PN}/examples/${i}"
			doexe "${BUILD_DIR}/EXAMPLES/${i}"/*
		done

		if use mpi; then
			exeinto "/usr/libexec/${PN}/examples/MPI"
			doexe "${BUILD_DIR}"/PARPACK/EXAMPLES/MPI/*
		fi

		if use python; then
			docinto examples/pyarpack
			dodoc "${BUILD_DIR}"/*.py
		fi
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
	if use icbexmm; then
		exeinto "/usr/libexec/${PN}/examples/MATRIX_MARKET"
		doexe "${BUILD_DIR}/EXAMPLES/MATRIX_MARKET/arpackmm"
		rm "${BUILD_DIR}/EXAMPLES/MATRIX_MARKET/arpackmm" || die
		docinto examples
		dodoc -r "${BUILD_DIR}/EXAMPLES/MATRIX_MARKET"
	fi
	if use python; then
		python_domodule "${ED}/usr/$(get_libdir)/pyarpack"
		rm -r "${ED}/usr/$(get_libdir)/pyarpack" || die
	fi
}
