# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit cmake-utils python-r1 git-r3

DESCRIPTION="Cheminformatics and machine-learning software written in C++ and Python"
HOMEPAGE="http://www.rdkit.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/rdkit/rdkit.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+python -static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/boost
	python? (
		dev-libs/boost[python,${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	>=dev-db/sqlite-3"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX:PATH="${EPREFIX}"/usr
		-DRDK_INSTALL_INTREE=0
		-DRDK_BUILD_CPP_TESTS=OFF
		$(cmake-utils_use static-libs RDK_INSTALL_STATIC_LIBS)
		$(cmake-utils_use python RDK_BUILD_PYTHON_WRAPPERS)
	)

	cmake-utils_src_configure
}
