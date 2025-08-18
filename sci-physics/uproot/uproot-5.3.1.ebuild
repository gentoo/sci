# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=hatchling
export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1 pypi

DESCRIPTION="ROOT I/O in pure Python and Numpy."
HOMEPAGE="https://github.com/scikit-hep/uproot"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/awkward-2.4.6[${PYTHON_USEDEP}]
	>=dev-python/cramjam-2.5.0[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/fsspec[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

# way too many missing packages, isal, deflate, xxhash, http servers etc
# distutils_enable_tests pytest
