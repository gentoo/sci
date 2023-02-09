# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_10 )

inherit distutils-r1

DESCRIPTION="Read/write Python types to/from HDF5 files, including MATLAB v7.3 MAT files"
HOMEPAGE="https://github.com/frejanordsiek/hdf5storage"

SRC_URI="https://github.com/frejanordsiek/hdf5storage/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
