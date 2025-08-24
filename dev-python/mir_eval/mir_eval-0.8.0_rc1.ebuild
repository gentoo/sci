# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Evaluation functions for music/audio information retrieval/signal processing"
HOMEPAGE="https://github.com/mir-evaluation/mir_eval"
SRC_URI="
	https://github.com/mir-evaluation/mir_eval/archive/${PV/_rc/rc}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${P/_rc/rc}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/decorator[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/numpydoc dev-python/sphinx-rtd-theme dev-python/matplotlib

python_prepare_all() {
	sed -i -e 's:--cov[a-z-]*\(=\| \)[^ ]*.::g' setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	cd "tests" || die
	epytest
}
