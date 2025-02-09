# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

DOCS_BUILDER="sphinx"
DOCS_DEPEND="
	dev-python/numpydoc
	dev-python/sphinx-rtd-theme
	dev-python/matplotlib
"
DOCS_DIR="docs"

inherit distutils-r1 docs

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
	dev-python/numpy
	dev-python/scipy
	dev-python/decorator
"
BDEPEND="
	test? (
		dev-python/matplotlib
	)
"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov[a-z-]*\(=\| \)[^ ]*.::g' setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	cd "tests" || die
	epytest
}
