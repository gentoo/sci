# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tools for sequencing FAST5 data from Oxford Nanopore"
HOMEPAGE="https://poretools.readthedocs.io
	https://github.com/arq5x/poretools"
SRC_URI="https://github.com/arq5x/poretools/archive/v0.6.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2" # https://github.com/arq5x/poretools/issues/136
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-libs/hdf5-1.8.7
	>=dev-python/h5py-2.2[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/seaborn[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]"
