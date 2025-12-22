# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1

MY_HASH="a7059ef691e74aeb018edaf37df49c99f6efed60"

DESCRIPTION="Conversion and validation tools for BEP 032"
HOMEPAGE="https://github.com/INT-NIT/BEP032tools"
SRC_URI="https://github.com/INT-NIT/BEP032tools/archive/${MY_HASH}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pynwb[${PYTHON_USEDEP}]
	dev-python/neo[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/parameterized[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${MY_HASH}"

# Require nixio
EPYTEST_DESELECT=(
	"bep032tools/generator/tests/test_BEP032Generator.py::Test_BEP032Data_ece::test_data_file_conversion_0_nix"
	"bep032tools/generator/tests/test_BEP032Generator.py::Test_BEP032Data_ece::test_data_file_conversion_multi_split"
	"bep032tools/generator/tests/test_BEP032Generator.py::Test_BEP032Data_ice::test_data_file_conversion_0_nix"
)
# Require dynamically fetched data
EPYTEST_DESELECT+=(
	"bep032tools/generator/tests/test_nwb2bidsgenerator.py::TestNwbBIDSGenerator::test_nwb_to_bids"
	"bep032tools/generator/tests/test_nwb2bidsgenerator.py::TestNwbBIDSGenerator::test_validation"
)

distutils_enable_tests pytest
