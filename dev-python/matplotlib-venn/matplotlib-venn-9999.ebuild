# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Routines for plotting area-weighted two- and three-circle venn diagrams"
HOMEPAGE="http://pysurfer.github.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/konstantint/matplotlib-venn"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="test? (
		${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp "${S}"/setup.py "${TEST_DIR}"/lib/ || die
	cp -r "${S}"/tests "${TEST_DIR}"/lib/ || die
	py.test || die "Tests fail with ${EPYTHON}"
}
