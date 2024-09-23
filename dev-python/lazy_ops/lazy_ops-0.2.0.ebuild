# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 pypi

DESCRIPTION="Lazy transposing and slicing of h5py and Zarr data"
HOMEPAGE="https://github.com/catalystneuro/lazy_ops"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
# There are no source archive with tests available:
# https://github.com/catalystneuro/lazy_ops/issues/29
RESTRICT="test"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/zarr[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
