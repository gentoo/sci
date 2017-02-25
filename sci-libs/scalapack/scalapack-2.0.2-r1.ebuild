# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit alternatives-2 cmake-utils eutils fortran-2

DESCRIPTION="Subset of LAPACK routines redesigned for heterogenous computing"
HOMEPAGE="http://www.netlib.org/scalapack/"
SRC_URI="${HOMEPAGE}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"

RDEPEND="
	virtual/lapack
	virtual/mpi
	!sci-libs/mpiblacs"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# gentoo fix to avoid collision with other scalapack
	sed -i \
		-e 's:BINARY_DIR}/scalapack.pc:BINARY_DIR}/refscalapack.pc:g' \
		CMakeLists.txt || die
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
	# mpi does not have a pc file
	sed -i -e 's/mpi//' scalapack.pc.in || die
}

src_configure() {
	scalapack_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_LAPACK_BLAS=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
			$(cmake-utils_use_build test TESTING)
			$@
		)
		cmake-utils_src_configure
	}

	scalapack_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" scalapack_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	cmake-utils_src_compile
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use static-libs && \
		BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install

	insinto /usr/include/blacs
	doins BLACS/SRC/*.h

	insinto /usr/include/scalapack
	doins PBLAS/SRC/*.h

	alternatives_for scalapack reference 0 \
		/usr/$(get_libdir)/pkgconfig/scalapack.pc refscalapack.pc
}
