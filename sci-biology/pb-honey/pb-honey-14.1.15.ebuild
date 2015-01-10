# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Structural variant identification (SNV) using long reads (over 10kbp)"
HOMEPAGE="https://www.hgsc.bcm.edu/software/honey"
SRC_URI="http://sourceforge.net/projects/pb-jelly/files/PBHoney/PBHoney_14.1.15.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sci-biology/samtools
	sci-biology/blasr
	sci-biology/pysam[${PYTHON_USEDEP}]
	dev-python/h5py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
