# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Use SAM/BAM/Bowtie/FASTA/Q/GFF/GTF files in python, count reads, genomic intervals"
HOMEPAGE="http://www-huber.embl.de/users/anders/HTSeq"
SRC_URI="mirror://pypi/H/"${PN}"/"${P}".tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
