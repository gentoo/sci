# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="The Python Machine Learning Library"
HOMEPAGE="http://pybrain.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/pybrain/pybrain.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="sci-libs/scipy[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND} )
	"

python_test() {
	python pybrain/tests/runtests.py || die
}
