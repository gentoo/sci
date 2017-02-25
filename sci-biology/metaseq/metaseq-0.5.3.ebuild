# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Framework for integrated analysis and plotting of ChIP/RIP/RNA/*-seq data"
HOMEPAGE="http://pythonhosted.org/metaseq/"
SRC_URI="https://github.com/daler/metaseq/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	sci-biology/bx-python[${PYTHON_USEDEP}]
	sci-biology/gffutils[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]
	sci-biology/pybedtools[${PYTHON_USEDEP}]
	sci-biology/samtools:0[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}"
