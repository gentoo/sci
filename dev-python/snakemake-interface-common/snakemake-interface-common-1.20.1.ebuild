# Copyright 1999-2025 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit pypi distutils-r1

DESCRIPTION="Common functions and classes for Snakemake and its plugins"
HOMEPAGE="https://pypi.org/project/snakemake-interface-common/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-python/argparse-dataclass[${PYTHON_USEDEP}]
	dev-python/configargparse[${PYTHON_USEDEP}]"

RESTRICT="test" # no tests collected
#distutils_enable_tests pytest
