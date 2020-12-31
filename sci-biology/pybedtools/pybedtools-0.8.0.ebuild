# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Use BED and GFF files from python using BEDtools"
HOMEPAGE="https://daler.github.io/pybedtools"
SRC_URI="https://github.com/daler/pybedtools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"
RESTRICT="test"
# Tests reported to fail on Gentoo:
# https://github.com/daler/pybedtools/issues/329

# see requirements.txt
RDEPEND="
	sci-biology/bedtools
	sci-biology/pysam
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	!minimal? ( sci-libs/htslib )"
# optional-requirements.txt also lists:
# ucsc-bigwigtobedgraph
# ucsc-bedgraphtobigwig
# ucsc-wigtobigwig
BDEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

# ToDo: fix docs building
# ModuleNotFoundError: No module named 'pybedtools.cbedtools'
# even if pybedtools is installed
#distutils_enable_sphinx docs/source
distutils_enable_tests pytest

src_compile(){
	python setup.py cythonize
	distutils-r1_src_compile
}
