# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit cmake-utils fortran-2 python-any-r1

MYP=lapack-${PV}

DESCRIPTION="Test Matrix Generator library for LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
	virtual/pkgconfig"

S="${WORKDIR}/${MYP}"

src_prepare() {
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

src_configure() {
	tmg_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_BLAS=ON
			-DUSE_OPTIMIZED_LAPACK=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
			-DTESTING=ON
			$@
		)
		cmake-utils_src_configure
	}

	tmg_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" tmg_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	cmake-utils_src_compile -C TESTING/MATGEN
	use static-libs && BUILD_DIR="${WORKDIR}/${PN}_static" \
		cmake-utils_src_compile -C TESTING/MATGEN
}

src_install() {
	cmake-utils_src_install -C TESTING/MATGEN
	use static-libs \
		&& BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install -C TESTING/MATGEN
}
