# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=hatchling
inherit distutils-r1 pypi
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

DESCRIPTION="Native Dask collection for awkward arrays, and the library to use it."
HOMEPAGE="
	https://github.com/dask-contrib/dask-awkward
	https://pypi.org/project/dask-awkward/
	https://dask-awkward.readthedocs.io/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/awkward-2.5.1[${PYTHON_USEDEP}]
	>=dev-python/dask-2023.04.0[${PYTHON_USEDEP}]
	dev-python/cachetools[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.8.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"
