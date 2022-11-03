# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Python package to handle probe layout, geometry and wiring to device"
HOMEPAGE="https://github.com/SpikeInterface/probeinterface"
SRC_URI="https://github.com/SpikeInterface/probeinterface/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

EPYTEST_DESELECT=(
	# Requires network access:
	# https://github.com/SpikeInterface/probeinterface/issues/70
	tests/test_library.py::test_download_probeinterface_file
	tests/test_library.py::test_get_from_cache
	tests/test_library.py::test_get_probe
	tests/test_wiring.py::test_wire_probe
)
distutils_enable_tests pytest
