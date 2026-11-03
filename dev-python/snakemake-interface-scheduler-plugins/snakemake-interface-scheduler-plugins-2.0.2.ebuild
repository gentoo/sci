# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1

DESCRIPTION="The interface for Snakemake scheduler plugins"
HOMEPAGE="https://pypi.org/project/snakemake-interface-scheduler-plugins/"
SRC_URI="https://github.com/snakemake/snakemake-interface-scheduler-plugins/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/snakemake-interface-common[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/snakemake[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

python_test() {
	epytest tests/tests.py
}
