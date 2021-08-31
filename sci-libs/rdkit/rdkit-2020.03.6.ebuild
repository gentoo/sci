# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit cmake python-r1

DESCRIPTION="Cheminformatics and machine-learning software written in C++ and Python"
HOMEPAGE="http://www.rdkit.org/"
SRC_URI="
	https://github.com/rdkit/rdkit/archive/Release_${PV//./_}.tar.gz -> ${P}.tar.gz
	https://github.com/schrodinger/maeparser/archive/v1.2.3.tar.gz -> maeparser-1.2.3.tar.gz
	https://github.com/schrodinger/coordgenlibs/archive/v1.4.0.tar.gz -> coordgenlibs-1.4.0.tar.gz
	https://github.com/Tencent/rapidjson/archive/v1.1.0.tar.gz -> rapidjson-1.1.0.tar.gz
	"
# issues with bundled packages; dev-libs/rapidjson, at least, should be unbundled:
# https://github.com/rdkit/rdkit/issues/3443

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
# build configuration issues https://github.com/rdkit/rdkit/issues/3444
IUSE="+python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/boost
	python? (
		dev-libs/boost[python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		${PYTHON_DEPS}
	)
	>=dev-db/sqlite-3"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/rdkit-Release_${PV//./_}

PATCHES=( "${FILESDIR}"/${P}-no_dynamic_checking.patch )

src_prepare() {
	cp ../maeparser-* -rf External/CoordGen/ || die
	cp ../coordgenlibs-* -rf External/CoordGen/ || die
	cp ../rapidjson-* -rf External/ || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}"/usr
		-DRDK_INSTALL_INTREE=0
		-DRDK_BUILD_CPP_TESTS=OFF
		-DRDK_INSTALL_STATIC_LIBS="$(usex static-libs)"
		-DRDK_BUILD_PYTHON_WRAPPERS="$(usex python)"
	)
	cmake_src_configure
}
