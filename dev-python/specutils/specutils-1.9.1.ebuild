# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Package for spectroscopic astronomical data"
HOMEPAGE="https://github.com/astropy/specutils"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Requires access to the internet
RESTRICT="test"

RDEPEND="
	dev-python/asdf[${PYTHON_USEDEP}]
	>=dev-python/astropy-4.0[${PYTHON_USEDEP}]
	dev-python/astropy-helpers[${PYTHON_USEDEP}]
	dev-python/gwcs[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
"

# Bug: https://bugs.gentoo.org/703778
#distutils_enable_sphinx docs dev-python/sphinx-astropy
distutils_enable_tests pytest

python_prepare_all() {
	# do not depend on pytest-datafiles
	sed -i -e '/addopts =/d' setup.cfg || die

	distutils-r1_python_prepare_all
}
