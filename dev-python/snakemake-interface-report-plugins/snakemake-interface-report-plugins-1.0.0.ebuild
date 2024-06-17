# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..12} )

inherit pypi distutils-r1

DESCRIPTION="The interface for Snakemake report plugins"
HOMEPAGE="https://pypi.org/project/snakemake-interface-report-plugins/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/snakemake-interface-common[${PYTHON_USEDEP}]"

RESTRICT="test" # no tests collected
#distutils_enable_tests pytest
