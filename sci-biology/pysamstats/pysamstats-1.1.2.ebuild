# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Calculate stats against genome positions from SAM/BAM/CRAM file"
HOMEPAGE="https://github.com/alimanfoo/pysamstats
	https://pypi.python.org/pypi/pysamstats"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: fix this
# ModuleNotFoundError: No module named 'pysamstats.opt'
# happens even with the --install option
RESTRICT="test"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
