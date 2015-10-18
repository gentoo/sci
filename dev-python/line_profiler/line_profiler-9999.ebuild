# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="Line-by-line profiling for Python"
HOMEPAGE="https://github.com/rkern/line_profiler"
EGIT_REPO_URI="https://github.com/rkern/${PN}.git git://github.com/rkern/${PN}.git"

LICENSE="BSD"
SLOT="0"
IUSE="test"

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	"

python_test() {
	distutils_install_for_testing
	cd "${TEST_DIR}"/lib || die
	cp "${S}"/setup.py "${TEST_DIR}"/lib/ || die
	cp -r "${S}"/tests "${TEST_DIR}"/lib/ || die
	py.test || die
}
