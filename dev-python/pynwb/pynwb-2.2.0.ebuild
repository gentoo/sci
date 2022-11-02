# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Python API for working with Neurodata stored in the NWB Format "
HOMEPAGE="https://github.com/NeurodataWithoutBorders/pynwb"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/hdf5[ros3(-)]
	>=dev-python/hdmf-3.3.2[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	"
BDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-versions.patch"
	)

EPYTEST_DESELECT=(
	# Reported upsream:
	# https://github.com/NeurodataWithoutBorders/pynwb/issues/1580
	tests/back_compat/test_read.py::TestReadOldVersions::test_read
	tests/back_compat/test_read.py::TestReadOldVersions::test_read_imageseries_non_external_format
	tests/back_compat/test_read.py::TestReadOldVersions::test_read_imageseries_nonmatch_starting_frame
	tests/unit/test_image.py::ImageSeriesConstructor::test_external_file_with_data
	tests/unit/test_image.py::ImageSeriesConstructor::test_external_file_with_data_construct_mode
	tests/unit/test_image.py::ImageSeriesConstructor::test_external_file_with_incorrect_format
	tests/unit/test_image.py::ImageSeriesConstructor::test_external_file_with_incorrect_format_construct_mode
	tests/unit/test_image.py::ImageSeriesConstructor::test_external_file_with_incorrect_starting_frame
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
