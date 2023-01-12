# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="The Hierarchical Data Modeling Framework"
HOMEPAGE="https://github.com/hdmf-dev/hdmf"
SRC_URI="https://github.com/hdmf-dev/hdmf/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/jsonschema[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	"
BDEPEND=""

distutils_enable_tests pytest

# Known to upstream:
# https://github.com/hdmf-dev/hdmf/issues/687
EPYTEST_DESELECT=(
	tests/unit/utils_test/test_labelleddict.py::TestLabelledDict::test_set_key_attr
)

PATCHES=(
	"${FILESDIR}/${P}-versions.patch"
)
