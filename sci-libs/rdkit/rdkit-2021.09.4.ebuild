# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )

inherit cmake python-single-r1

DESCRIPTION="Cheminformatics and machine-learning software written in C++ and Python"
HOMEPAGE="http://www.rdkit.org/"
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
	"${FILESDIR}/${PN}-2021.09.4-find-rapidjson.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCATCH_DIR="${EPREFIX}/usr/include/catch2"
		-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}/usr"
		-DRDK_INSTALL_INTREE=0
		-DRDK_BUILD_CPP_TESTS="$(usex test)"
		-DRDK_INSTALL_STATIC_LIBS="$(usex static-libs)"
		-DRDK_BUILD_PYTHON_WRAPPERS="$(usex python)"
		# Disable things that trigger fetching and are not packaged
		-DRDK_INSTALL_COMIC_FONTS=OFF
		-DRDK_BUILD_COORDGEN_SUPPORT=OFF
		-DRDK_BUILD_MAEPARSER_SUPPORT=OFF
		-DRDK_USE_URF=OFF
	)
	cmake_src_configure
}

src_test() {
	RDBASE="${WORKDIR}/${PN}-Release_2021_09_4_build" cmake_src_test
}
