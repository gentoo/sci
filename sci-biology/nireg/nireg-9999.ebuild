# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1 git-r3

DESCRIPTION="Image registration package for Python"
HOMEPAGE="http://nipy.org/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/nipy/${PN}"

LICENSE="BSD"
SLOT="0"
IUSE="test"
KEYWORDS=""

COMMONDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${COMMONDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"
RDEPEND="${COMMONDEPEND}
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-libs/nibabel[${PYTHON_USEDEP}]
	"

python_test() {
	#nosetests -v || die
	python -c "import nireg; nireg.test()" || die
}
