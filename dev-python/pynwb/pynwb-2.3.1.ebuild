# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1 pypi

DESCRIPTION="A Python API for working with Neurodata stored in the NWB Format "
HOMEPAGE="https://github.com/NeurodataWithoutBorders/pynwb"
SRC_URI="$(pypi_sdist_url pynwb)"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=sci-libs/hdf5-1.12.2
	>=dev-python/hdmf-3.3.2[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	"
BDEPEND=""

# Remove in next release
PATCHES=(
	"${FILESDIR}/${P}-typing.patch"
	)

EPYTEST_DESELECT=(
	# Reported upsream:
	# https://github.com/NeurodataWithoutBorders/pynwb/issues/1580
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached_bad_ns
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached_core
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached_extension
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached_extension_pass_ns
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached_hdmf_common
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_cached_ignore
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_invalid
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_list_namespaces_core
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_list_namespaces_extension
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_no_cache
	tests/validation/test_validate.py::TestValidateCLI::test_validate_file_no_cache_bad_ns
)

distutils_enable_tests pytest
