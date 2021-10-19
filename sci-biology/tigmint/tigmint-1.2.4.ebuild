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
KEYWORDS="~amd64 ~x86"

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
