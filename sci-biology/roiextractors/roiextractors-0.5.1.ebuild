# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Optical imaging data handling from several file formats"
HOMEPAGE="https://github.com/catalystneuro/roiextractors"
SRC_URI="https://github.com/catalystneuro/roiextractors/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	dev-python/dill[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/lazy_ops[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pynwb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
		dev-python/spikeinterface[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	epytest tests/test_internals
}
