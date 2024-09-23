# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Python library for the Advanced Scientific Data Format"
HOMEPAGE="https://asdf.readthedocs.io/en/latest/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
# Reported upstream:
# https://github.com/asdf-format/asdf/issues/1319
RESTRICT="test"

BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/astropy[${PYTHON_USEDEP}]
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/gwcs[${PYTHON_USEDEP}]
	)
	doc? ( media-gfx/graphviz )
"

RDEPEND="
	>=dev-python/jmespath-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/jsonschema-3.0.2[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.10[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/semantic-version-2.8[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/astropy dev-python/sphinx-astropy dev-python/matplotlib dev-python/docutils

python_test() {
	# discovers things in docs dir if we do not
	# explicitly set it to run on the tests dir
	epytest asdf/tests
}
