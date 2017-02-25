# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="A simple library for making your data dimensionful"
HOMEPAGE="https://github.com/caseywstark/dimensionful"
SRC_URI=""
EGIT_REPO_URI="git://github.com/caseywstark/dimensionful.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="dev-python/sympy[${PYTHON_USEDEP}]"

python_test() {
	local t
	for t in test/test_*.py; do
		${EPYTHON} "${t}" || die
	done
}
