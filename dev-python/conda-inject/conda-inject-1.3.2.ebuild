# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{12..15} )

inherit pypi distutils-r1

DESCRIPTION="Helper functions for injecting a conda environment into the current python environment"
HOMEPAGE="https://pypi.org/project/conda-inject/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"

# tests all require conda; also not included in pypi
RESTRICT="test"
