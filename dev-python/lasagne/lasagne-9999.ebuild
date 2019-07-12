# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_5,3_6} )

inherit distutils-r1 git-r3

DESCRIPTION="Lightweight library to build and train neural networks in Theano"
HOMEPAGE="https://github.com/Lasagne/Lasagne"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Lasagne/Lasagne"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-pep8[${PYTHON_USEDEP}]
		)
	"
RDEPEND="
	>=dev-python/theano-0.8.2
	"

python_test() {
	py.test --runslow --cov-config=.coveragerc-nogpu || die
}
