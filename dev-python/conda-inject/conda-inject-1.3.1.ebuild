# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit pypi distutils-r1

DESCRIPTION="Helper functions for injecting a conda environment into the current python environment"
HOMEPAGE="https://pypi.org/project/conda-inject/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

RESTRICT="test" # no tests collected
#distutils_enable_tests pytest
