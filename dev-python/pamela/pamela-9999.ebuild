# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1 git-r3

DESCRIPTION="PAM interface using ctypes"
HOMEPAGE="https://github.com/minrk/pamela"
EGIT_REPO_URI="https://github.com/minrk/${PN}.git git://github.com/minrk/${PN}.git"
KEYWORDS=""

LICENSE="MIT"
SLOT="0"
IUSE="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test --assert=plain test_pamela.py
}
