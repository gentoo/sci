# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/armadillo/armadillo-3.2.4.ebuild,v 1.1 2012/07/20 21:51:23 bicatali Exp $

EAPI=4

CMAKE_IN_SOURCE_BUILD=1

inherit cmake-utils

DESCRIPTION="Streamlined C++ linear algebra library"
HOMEPAGE="http://arma.sourceforge.net/"
SRC_URI="mirror://sourceforge/arma/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="atlas blas doc examples lapack"

RDEPEND=">=dev-libs/boost-1.34
	atlas? ( sci-libs/atlas )
	blas? ( virtual/blas )
	lapack? ( virtual/lapack )"

DEPEND="${DEPEND}
	virtual/pkgconfig"

src_prepare() {
	# avoid the automagic cmake macros
	sed -i -e '/ARMA_Find/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=()
	if use blas; then
		mycmakeargs+=(
			-DBLAS_FOUND=ON
			-DBLAS_LIBRARIES="$(pkg-config --libs blas)"
		)
	fi
	if use lapack; then
		mycmakeargs+=(
			-DLAPACK_FOUND=ON
			-DLAPACK_LIBRARIES="$(pkg-config --libs lapack)"
		)
	fi
	if use atlas; then
		local c=atlas-cblas l=atlas-lapac
		pkg-config --exists atlas-cblas-threads && c+=-threads
		pkg-config --exists atlas-lapack-threads && l+=-threads
		mycmakeargs=(
			-DARMA_USE_ATLAS=ON
			-DCBLAS_FOUND=ON
			-DCLAPACK_FOUND=ON
			-DATLAS_INCLUDE_DIR="$(pkg-config --cflags ${c} | sed 's/-I//')"
			-DCBLAS_LIBRARIES="$(pkg-config --libs ${c})"
			-DCLAPACK_LIBRARIES="$(pkg-config --libs ${l})"
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc README.txt
	use doc && dodoc docs/*pdf
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
