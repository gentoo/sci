# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="Google Cloud Storage API client library"
HOMEPAGE="https://github.com/googleapis/python-storage"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/google-auth[${PYTHON_USEDEP}]
	dev-python/google-api-core[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

RESTRICT="test" # ImportError: cannot import name '_helpers' from 'google.cloud'
#distutils_enable_tests pytest
