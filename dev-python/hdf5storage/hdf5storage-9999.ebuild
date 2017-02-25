# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 git-r3

DESCRIPTION="Read/write Python types to/from HDF5 files, including MATLAB v7.3 MAT files"
HOMEPAGE="https://github.com/frejanordsiek/hdf5storage"
EGIT_REPO_URI="https://github.com/frejanordsiek/${PN}.git git://github.com/frejanordsiek/${PN}.git"

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"