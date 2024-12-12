# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="Correct misassemblies using linked reads from 10x Genomics Chromium"
HOMEPAGE="https://github.com/bcgsc/tigmint https://bcgsc.github.io/tigmint/"
SRC_URI="https://github.com/bcgsc/tigmint/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"
PROPERTIES="test_network"

RDEPEND="
	dev-python/intervaltree[${PYTHON_USEDEP}]
	dev-python/pybedtools[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]
	app-arch/pigz
	app-shells/zsh
	sci-biology/samtools
	sci-biology/minimap2
	sci-biology/seqtk
"

distutils_enable_tests pytest

src_prepare(){
	# install the executable into /usr/bin
	sed -i Makefile -e 's#prefix=/usr/local#prefix=/usr#'
	default
}

src_configure(){
	python_setup
	default
}

# do not run src_compile step as it runs git, makefile2graph, gsed, tred

python_install() {
	# This is a bit unorthodox, but it allows us to get both a symlink from
	# /usr/bin to our script using the correct python implementation
	# *and* to import it from the python shell
	python_domodule bin/*.py
	python_domodule bin/tigmint-arcs-tsv
	python_domodule bin/tigmint-cut

	python_doscript bin/*.py
	python_doscript bin/tigmint-arcs-tsv
	python_doscript bin/tigmint-cut
}

python_install_all() {
	dobin bin/tigmint
	dobin bin/tigmint-make
}

src_test(){
	default
	distutils-r1_src_test
}
