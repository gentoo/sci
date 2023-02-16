# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Sphinx extensions and configuration specific to the Astropy project"
HOMEPAGE="https://www.astropy.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# Requires access to the internet
RESTRICT="test"

RDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/astropy-sphinx-theme[${PYTHON_USEDEP}]
	dev-python/numpydoc[${PYTHON_USEDEP}]
	>=dev-python/sphinx-1.7[${PYTHON_USEDEP}]
	dev-python/sphinx-automodapi[${PYTHON_USEDEP}]
	dev-python/sphinx-gallery[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
