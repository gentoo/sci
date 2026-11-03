# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Stable interface for interactions between Snakemake and its executor plugins"
HOMEPAGE="https://pypi.org/project/snakemake-interface-executor-plugins/"
SRC_URI="https://github.com/snakemake/snakemake-interface-executor-plugins/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/argparse-dataclass[${PYTHON_USEDEP}]
	dev-python/snakemake-interface-common[${PYTHON_USEDEP}]
	dev-python/throttler[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires separate ebuild for cluster-generic
		tests/tests.py::TestRegistry::test_registry_collect_plugins
		tests/tests.py::TestRegistry::test_registry_register_cli_args
		tests/tests.py::TestRegistry::test_registry_cli_args_to_settings
	)
	epytest tests/tests.py
}
