# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Use BED and GFF files from python using BEDtools"
HOMEPAGE="https://daler.github.io/pybedtools"
SRC_URI="https://github.com/daler/pybedtools/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc minimal"
RESTRICT="test"
# Tests reported to fail on Gentoo:
# https://github.com/daler/pybedtools/issues/329

# see requirements.txt
RDEPEND="
	sci-biology/bedtools
	sci-biology/pysam
	dev-python/numpy
	dev-python/pandas
	!minimal? ( sci-libs/htslib )
	doc? ( dev-python/sphinx )"
# optional-requirements.txt also lists:
# ucsc-bigwigtobedgraph
# ucsc-bedgraphtobigwig
# ucsc-wigtobigwig
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]"

src_compile(){
	python setup.py cythonize
	distutils-r1_src_compile
	use doc && cd docs && emake html
}

src_install(){
	distutils-r1_src_install
	if use doc; then
		insinto /usr/share/doc/"${PN}"
		doins -r docs/build/html
	fi
}

distutils_enable_tests pytest
