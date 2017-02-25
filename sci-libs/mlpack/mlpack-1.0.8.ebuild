# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils eutils toolchain-funcs

DESCRIPTION="Scalable c++ machine learning library"
HOMEPAGE="http://www.mlpack.org/"
SRC_URI="http://www.mlpack.org/files/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc"

RDEPEND="
	dev-libs/boost
	dev-libs/libxml2
	>=sci-libs/armadillo-3.6.0[lapack]"

DEPEND="${DEPEND}
	app-text/txt2man
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

DOCS=( HISTORY.txt )

src_prepare() {
	epatch \
		"${FILESDIR}/${PN}-1.0.4-libdir.patch" \
		"${FILESDIR}/${PN}-1.0.8-uint32_t.patch"
	sed -i \
		-e "s:share/doc/mlpack:share/doc/${PF}:" \
		-e 's/-O3//g' \
		CMakeLists.txt || die
	sed -i \
		-e "s|\(set(ARMADILLO_LIBRARIES\)|\1 $($(tc-getPKG_CONFIG) --libs blas lapack)|" \
		CMake/FindArmadillo.cmake || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use debug DEBUG)
		$(cmake-utils_use debug PROFILE)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(use doc && echo doc)
}

src_test() {
	emake -C "${BUILD_DIR}" test
}
