# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python{3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Core common functionality of Jupyter projects"
HOMEPAGE="http://jupyter.org"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://raw.githubusercontent.com/gentoo-science/sci/master/patches/${P}-tests-dotipython.patch"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/traitlets[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-cov[${PYTHON_USEDEP}]
			dev-python/mock[${PYTHON_USEDEP}] )
	"

PATCHES=(
	"${FILESDIR}"/${P}-add-test-files.patch
	"${DISTDIR}"/${P}-tests-dotipython.patch
)

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	py.test jupyter_core || die
}
