# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils toolchain-funcs cmake-utils alternatives-2

MYP=lapack-${PV}

DESCRIPTION="Reference implementation of LAPACK"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/lapack/${MYP}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs test xblas"

RDEPEND="virtual/blas
	virtual/fortran
	xblas? ( sci-libs/xblas )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( README )

S="${WORKDIR}/${MYP}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-blas-libs.patch \
		"${FILESDIR}"/${PV}-xblas-libs.patch
	# avoid collision with other lapack
	sed -i \
		-e 's:BINARY_DIR}/lapack.pc:BINARY_DIR}/reflapack.pc:' \
		-e '/export/s:lapack:reflapack:g' \
		CMakeLists.txt || die
	sed -i \
		-e 's:(lapack:(reflapack:g' \
		SRC/CMakeLists.txt || die
	sed -i \
		-e 's:lapack:reflapack:g' \
		TESTING/*/CMakeLists.txt || die
	sed -i \
		-e 's:-llapack:-lreflapack:g' \
		lapack.pc.in || die
	export FC=$(tc-getFC) F77=$(tc-getF77)
	use static-libs && mkdir "${WORKDIR}/${PN}_static"
}

lapack_configure() {
	mycmakeargs+=(
		-DUSE_OPTIMIZED_BLAS=ON
		-DBLAS_LIBRARIES="$(pkg-config --libs blas)"
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use xblas XBLAS)
	)
	cmake-utils_src_configure
}

src_configure() {
	mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
	lapack_configure
	if use static-libs; then
		mycmakeargs=( -DBUILD_SHARED_LIBS=OFF )
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" lapack_configure
	fi
}

src_compile() {
	cmake-utils_src_compile
	if use static-libs; then
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_compile
	fi
}

src_install() {
	cmake-utils_src_install
	if use static-libs; then
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install
	fi
	alternatives_for lapack reference 0 \
		"/usr/$(get_libdir)/pkgconfig/lapack.pc" "reflapack.pc"
}
