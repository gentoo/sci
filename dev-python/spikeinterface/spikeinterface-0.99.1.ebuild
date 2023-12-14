# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A Python-based module for creating flexible and robust spike sorting pipelines."
HOMEPAGE="https://github.com/SpikeInterface/spikeinterface"
SRC_URI="https://github.com/SpikeInterface/spikeinterface/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="extractors full test"
# Reported upstream:
# https://github.com/SpikeInterface/spikeinterface/issues/2339
RESTRICT="test"

RDEPEND="
	dev-python/joblib[${PYTHON_USEDEP}]
	dev-python/neo[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/probeinterface-0.2.16[${PYTHON_USEDEP}]
	dev-python/threadpoolctl[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	extractors? (
		dev-python/pynwb[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
	full? (
		dev-python/distinctipy[${PYTHON_USEDEP}]
		dev-python/h5py[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/networkx[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		dev-python/zarr[${PYTHON_USEDEP}]
		sci-libs/scikit-learn[${PYTHON_USEDEP}]
	)
"
# Also wants:
# # Extractors:
# 	MEArec
# 	pyedflib
# 	sonpy
# 	dev-python/hdf5storage (in ::science, masked)

distutils_enable_tests pytest
