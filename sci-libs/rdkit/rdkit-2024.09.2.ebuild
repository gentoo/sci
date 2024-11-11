# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
CMAKE_IN_SOURCE_BUILD=1

inherit cmake python-single-r1

DESCRIPTION="Cheminformatics and machine-learning software written in C++ and Python"
HOMEPAGE="https://www.rdkit.org/"
SRC_URI="https://github.com/rdkit/rdkit/archive/Release_${PV//./_}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rdkit-Release_${PV//./_}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+python static-libs test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost
	python? (
		$(python_gen_cond_dep '
		dev-libs/boost:=[numpy,python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
	dev-cpp/catch:0
	dev-libs/rapidjson
	>=dev-db/sqlite-3"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2024.03.4-find-rapidjson.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}/usr"
		-DRDK_INSTALL_INTREE=0
		-DRDK_BUILD_CPP_TESTS="$(usex test)"
		-DRDK_INSTALL_STATIC_LIBS="$(usex static-libs)"
		-DRDK_BUILD_PYTHON_WRAPPERS="$(usex python)"
		# Disable things that trigger fetching and are not packaged
		-DRDK_INSTALL_COMIC_FONTS=OFF
		-DRDK_BUILD_AVALON_SUPPORT=OFF
		-DRDK_BUILD_COORDGEN_SUPPORT=OFF
		-DRDK_BUILD_FREESASA_SUPPORT=OFF
		-DRDK_BUILD_INCHI_SUPPORT=OFF
		-DRDK_BUILD_MAEPARSER_SUPPORT=OFF
		-DRDK_BUILD_PUBCHEMSHAPE_SUPPORT=OFF
		-DRDK_BUILD_YAEHMOP_SUPPORT=OFF
		-DRDK_USE_URF=OFF
	)
	cmake_src_configure
}

src_test() {
	RDBASE="${S}" cmake_src_test
}
