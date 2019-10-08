# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Fast and scalable spike sorting in Python"
HOMEPAGE="http://spyking-circus.rtfd.org"
SRC_URI="https://github.com/spyking-circus/spyking-circus/archive/${PV}.tar.gz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

RDEPEND="
	dev-python/mpi4py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/blosc[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	sci-libs/scikits_learn[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
