# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Create NWB files from proprietary formats."
HOMEPAGE="https://github.com/catalystneuro/neuroconv"
SRC_URI="https://github.com/catalystneuro/neuroconv/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ecephys +icephys +ophys"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/hdmf[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/pynwb[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-vcs/dandi-cli[${PYTHON_USEDEP}]
	ecephys? (
		dev-python/spikeinterface[${PYTHON_USEDEP}]
	)
	icephys? (
		dev-python/neo[${PYTHON_USEDEP}]
	)
	ophys? (
		sci-biology/roiextractors[${PYTHON_USEDEP}]
	)
"
BDEPEND="
	test? (
		dev-python/parameterized[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	# Additional tests require complex data getting infrastructure, ophys tests still have issues:
	# https://github.com/catalystneuro/neuroconv/issues/305
	local my_tests=( "tests/test_minimal" )
	use ecephys && my_tests+=( "tests/test_ecephys" )
	#use ophys && my_tests+=( "tests/test_ophys" )
	epytest ${my_tests[*]// /|}
}
