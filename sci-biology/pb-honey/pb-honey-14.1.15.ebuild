# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Structural variant identification (SNV) using long reads (over 10kbp)"
HOMEPAGE="https://www.hgsc.bcm.edu/software/honey"
SRC_URI="http://sourceforge.net/projects/pb-jelly/files/PBHoney/PBHoney_14.1.15.tgz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/samtools
	sci-biology/blasr
	sci-biology/pysam
	dev-python/h5py
	dev-python/numpy"
RDEPEND="${DEPEND}"
