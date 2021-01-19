# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Utilities for RNA-seq data quality control"
HOMEPAGE="https://sourceforge.net/projects/rseqc/"
SRC_URI="https://sourceforge.net/projects/rseqc/files/RSeQC-${PV}.tar.gz
	https://sourceforge.net/projects/rseqc/files/other/fetchChromSizes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/nose[${PYTHON_USEDEP}]
"
RDEPEND="
	>=sci-biology/pysam-0.7.5[${PYTHON_USEDEP}]
	sci-biology/bx-python[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pyBigWig[${PYTHON_USEDEP}]
"

python_prepare_all() {
	distutils-r1_python_prepare_all
	# avoid file collision with bx-python
	rm lib/psyco_full.py || die
}
