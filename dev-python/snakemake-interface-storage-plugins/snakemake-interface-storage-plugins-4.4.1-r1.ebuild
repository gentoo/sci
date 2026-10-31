# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="Stable interface for interactions between Snakemake and its storage plugins"
HOMEPAGE="https://pypi.org/project/snakemake-interface-storage-plugins/"
SRC_URI="https://github.com/snakemake/snakemake-interface-storage-plugins/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/snakemake-interface-common[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/humanfriendly[${PYTHON_USEDEP}]
	>=dev-python/tenacity-9.1.4[${PYTHON_USEDEP}]
	dev-python/throttler[${PYTHON_USEDEP}]
"

RESTRICT="test" # requires separate ebuild for storage-http plugin
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest tests/tests.py
}
