# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python support for SAM/BAM/Bowtie/FASTA/Q/GFF/GTF files"
HOMEPAGE="http://www-huber.embl.de/users/anders/HTSeq"
SRC_URI="mirror://pypi/H/"${PN}"/"${P}".tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	sci-biology/pysam[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
