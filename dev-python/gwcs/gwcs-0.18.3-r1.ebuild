# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Generalized World Coordinate System"
HOMEPAGE="https://gwcs.readthedocs.io/en/latest/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# Tests do not pass, reported upstream:
# https://github.com/spacetelescope/gwcs/issues/437
RESTRICT=test

BDEPEND="dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-doctestplus[${PYTHON_USEDEP}]
	)
"

RDEPEND="
	dev-python/asdf[${PYTHON_USEDEP}]
	>=dev-python/astropy-4.1[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

# TODO: package stsci-rtd-theme
#distutils_enable_sphinx docs dev-python/sphinx-astropy dev-python/sphinx-automodapi dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

python_test() {
	# discovers things in docs dir if we do not
	# explicitly set it to run on the tests dir
	epytest gwcs/tests
}
