# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

CMAKE_IN_SOURCE_BUILD=1

inherit cmake-utils toolchain-funcs multilib eutils

DESCRIPTION="Streamlined C++ linear algebra library"
HOMEPAGE="http://arma.sourceforge.net/"
SRC_URI="mirror://sourceforge/arma/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="atlas blas debug doc examples hdf5 int64 lapack tbb"

RDEPEND="
	dev-libs/boost
	atlas? ( sci-libs/atlas[lapack] )
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )"
DEPEND="${DEPEND}
	atlas? ( virtual/pkgconfig )
	blas? ( virtual/pkgconfig )
	lapack? ( virtual/pkgconfig )"
PDEPEND="${RDEPEND}
	hdf5? ( sci-libs/hdf5 )
	tbb? ( dev-cpp/tbb )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.820.1-{hdf5,example-makefile}.patch
	# avoid the automagic cmake macros
	sed -i -e '/ARMA_Find/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
		$(cmake-utils_use debug ARMA_EXTRA_DEBUG)
		$(cmake-utils_use hdf5 ARMA_USE_HDF5)
		$(cmake-utils_use int64 ARMA_64BIT_WORD)
		$(cmake-utils_use tbb ARMA_TBB_ALLOC)
	)
	if use blas; then
		mycmakeargs+=(
			-DBLAS_FOUND=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
		)
	fi
	if use lapack; then
		mycmakeargs+=(
			-DLAPACK_FOUND=ON
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
		)
	fi
	if use atlas; then
		local c=atlas-cblas l=atlas-clapack
		$(tc-getPKG_CONFIG) --exists ${c}-threads && c+=-threads
		$(tc-getPKG_CONFIG) --exists ${l}-threads && l+=-threads
		mycmakeargs+=(
			-DCBLAS_FOUND=ON
			-DCLAPACK_FOUND=ON
			-DATLAS_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --cflags ${c} | sed 's/-I//')"
			-DCBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs ${c})"
			-DCLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs ${l})"
		)
	fi
	cmake-utils_src_configure
}

src_test() {
	pushd examples > /dev/null
	emake CXXFLAGS="-I../include ${CXXFLAGS}" EXTRA_LIB_FLAGS="-L.."
	LD_LIBRARY_PATH="..:${LD_LIBRARY_PATH}" ./example1 || die
	LD_LIBRARY_PATH="..:${LD_LIBRARY_PATH}" ./example2 || die
	emake clean
	popd > /dev/null
}

src_install() {
	cmake-utils_src_install
	dodoc README.txt
	use doc && dodoc *pdf && dohtml *html
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
