# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Common functions and classes for Snakemake and its plugins"
HOMEPAGE="https://pypi.org/project/snakemake-interface-common/"
SRC_URI="https://github.com/snakemake/snakemake-interface-common/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/argparse-dataclass[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]
	>=dev-python/packaging-26.1[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		tests/tests.py::test_snakemake_version
	)
	epytest tests/tests.py
}
