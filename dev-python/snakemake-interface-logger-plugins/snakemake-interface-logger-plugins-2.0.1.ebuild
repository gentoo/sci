# Copyright 1999-2026 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Snakemake Logger Plugin Interface"
HOMEPAGE="https://pypi.org/project/snakemake-interface-logger-plugins/"
SRC_URI="https://github.com/snakemake/snakemake-interface-logger-plugins/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/snakemake-interface-common[${PYTHON_USEDEP}]"

RESTRICT="test" # needs logger-rich plugin ebuild
distutils_enable_tests pytest

python_test() {
	epytest tests/tests.py
}
