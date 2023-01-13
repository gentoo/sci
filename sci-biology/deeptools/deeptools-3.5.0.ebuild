# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..10} )

inherit distutils-r1

DESCRIPTION="Extract reads from BAM files, normalize, draw figures, convert BAM to bigWig"
HOMEPAGE="https://github.com/deeptools/deepTools"
SRC_URI="https://github.com/deeptools/deepTools/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# TODO: fix this
RESTRICT="test"

RDEPEND="
	>=sci-biology/deeptools-intervals-0.1.8[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.9.0[${PYTHON_USEDEP}]
	>=dev-python/numpydoc-0.5[${PYTHON_USEDEP}]
	>=dev-python/scipy-0.17.0[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	>=dev-python/py2bit-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/pyBigWig-0.2.1[${PYTHON_USEDEP}]
	>=sci-biology/pysam-0.14.0[${PYTHON_USEDEP}]
	>=dev-python/matplotlib-3.1.0[${PYTHON_USEDEP}]
"

S="${WORKDIR}/deepTools-${PV}"

distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/sphinx-argparse
#distutils_enable_tests nose
