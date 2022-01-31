# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Python API for working with Neurodata stored in the NWB Format "
HOMEPAGE="https://github.com/NeurodataWithoutBorders/pynwb"
SRC_URI="https://github.com/NeurodataWithoutBorders/pynwb/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	sci-libs/hdf5[ros3]
	dev-python/hdmf[${PYTHON_USEDEP}]
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
	# https://github.com/dandi/dandischema/issues/87
	tests/validation/test_validate.py::TestValidateScript::test_validate_file_cached
	tests/validation/test_validate.py::TestValidateScript::test_validate_file_cached_bad_ns
	tests/validation/test_validate.py::TestValidateScript::test_validate_file_cached_hdmf_common
	tests/validation/test_validate.py::TestValidateScript::test_validate_file_cached_ignore
	tests/validation/test_validate.py::TestValidateScript::test_validate_file_no_cache
	tests/validation/test_validate.py::TestValidateScript::test_validate_file_no_cache_bad_ns
	# Reported upstream and fixed in newer version:
	# https://github.com/NeurodataWithoutBorders/pynwb/issues/1412#issuecomment-934153799
	tests/integration/ros3/test_ros3.py::TestRos3Streaming::test_dandi_read
	tests/integration/ros3/test_ros3.py::TestRos3Streaming::test_read
)

distutils_enable_tests pytest
