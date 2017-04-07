# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils eutils python-single-r1

DESCRIPTION="C++/Python interface of FEniCS"
HOMEPAGE="https://bitbucket.org/fenics-project/dolfin"
SRC_URI="https://bitbucket.org/fenics-project/${PN}/downloads/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpi parmetis petsc scotch trilinos umfpack zlib"
# scotch and parmetis require mpi; wait for EAPI 4

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	trilinos? ( mpi )"

DEPEND="
	${PYTHON_DEPS}
	dev-libs/boost
	dev-cpp/eigen:3
	dev-lang/swig
	dev-libs/libxml2:2
	~dev-python/ffc-${PV}[${PYTHON_USEDEP}]
	~dev-python/fiat-${PV}[${PYTHON_USEDEP}]
	~dev-python/instant-${PV}[${PYTHON_USEDEP}]
	dev-python/sympy
	~dev-python/ufl-${PV}[${PYTHON_USEDEP}]
	virtual/blas
	virtual/lapack
	mpi? ( virtual/mpi )
	parmetis? ( sci-libs/parmetis[mpi=] )
	petsc? ( sci-mathematics/petsc[mpi=] )
	sci-libs/armadillo
	scotch? ( sci-libs/scotch )
	trilinos? ( sci-libs/trilinos )
	umfpack? (
		sci-libs/amd
		sci-libs/cholmod
		sci-libs/umfpack
	)
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-trilinos-superlu.patch
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	# *sigh*
	addpredict /proc/mtrr
	addpredict /sys/devices/system/cpu/

	mycmakeargs=(
		-DDOLFIN_ENABLE_CHOLMOD="$(usex umfpack)"
		-DDOLFIN_ENABLE_MPI="$(usex mpi)"
		-DDOLFIN_ENABLE_PARMETIS="$(usex parmetis)"
		-DDOLFIN_ENABLE_PETSC="$(usex petsc)"
		-DDOLFIN_ENABLE_PYTHON="yes"
		-DDOLFIN_ENABLE_SCOTCH="$(usex scotch)"
		-DDOLFIN_ENABLE_TRILINOS="$(usex trilinos)"
		-DDOLFIN_ENABLE_UMFPACK="$(usex umfpack)"
		-DDOLFIN_ENABLE_ZLIB="$(usex zlib)"
	)
	cmake-utils_src_configure
}
