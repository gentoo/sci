# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Correct misassemblies using linked reads from 10x Genomics Chromium"
HOMEPAGE="https://github.com/bcgsc/tigmint https://bcgsc.github.io/tigmint/"
SRC_URI="https://github.com/bcgsc/tigmint/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

RESTRICT="test"

RDEPEND="
	dev-python/intervaltree[${PYTHON_USEDEP}]
	sci-biology/pybedtools[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]
	app-arch/pigz
	sci-biology/samtools
	sci-biology/minimap2
	sci-biology/seqtk
"

distutils_enable_tests pytest

# install the executable into /usr/bin
# BUG: the read_fasta.py should be installed into python modules
#   so it can be imported into python
src_prepare(){
	sed -i Makefile -e 's#prefix=/usr/local#prefix=/usr#'
	default
}

src_configure(){
	python_setup
	default
}

# do not run src_compile step as it runs git, makefile2graph, gsed, tred

src_install(){
	default
	distutils-r1_src_install
}

src_test(){
	default
	python_foreach_impl python_test
}
