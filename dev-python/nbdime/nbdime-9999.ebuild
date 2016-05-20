# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1 git-r3

DESCRIPTION="Diff and merge of Jupyter Notebooks"
HOMEPAGE="http://jupyter.org"
EGIT_REPO_URI="https://github.com/jupyter/${PN}.git"

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/testpath[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
	"
# Some additional packages (e.g. commonmark, recommonmark) are required to build the docs
# Furthermore, backports.shutil_which is required for python2_7.

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp -r "${S}/${PN}"/tests "${TEST_DIR}"/lib/ || die
	py.test -l || die
}
