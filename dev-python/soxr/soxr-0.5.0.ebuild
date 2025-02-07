# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=scikit-build-core
PYTHON_COMPAT=( pypy3 python3_{10..13} )

DOCS_BUILDER="sphinx"
DOCS_DEPEND="
	dev-python/linkify-it-py
	dev-python/sphinx-rtd-theme
	dev-python/myst-parser
"
DOCS_DIR="docs"

inherit distutils-r1 docs

DESCRIPTION="Fast and high quality sample-rate conversion library for Python"
HOMEPAGE="https://github.com/dofuuz/python-soxr/"
SRC_URI="
	https://github.com/dofuuz/python-soxr/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-soxr-${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/soxr
"
RDEPEND="
	${DEPEND}
	dev-python/numpy[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/nanobind[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

src_prepare() {
	sed -i 's:sphinx-book-theme:sphinx-rtd-theme:g' pyproject.toml || die
	sed -i 's:sphinx_book_theme:sphinx_rtd_theme:g' docs/conf.py || die
	distutils-r1_src_prepare
}

src_configure() {
	DISTUTILS_ARGS=(
		-DUSE_SYSTEM_LIBSOXR=ON
	)
}
