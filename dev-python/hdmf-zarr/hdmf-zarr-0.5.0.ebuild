# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=hatchling

inherit distutils-r1 pypi

DESCRIPTION="Zarr I/O backend for HDMF"
HOMEPAGE="https://github.com/hdmf-dev/hdmf-zarr"
#SRC_URI="https://github.com/hdmf-dev/hdmf-zarr/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/hdmf[${PYTHON_USEDEP}]
	dev-python/numcodecs[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pynwb[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
	dev-python/zarr[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-coverage.patch"
)

distutils_enable_tests pytest
