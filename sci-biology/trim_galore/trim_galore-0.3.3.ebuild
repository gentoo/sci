# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Wrapper around Cutadapt and FastQC to consistently apply quality and adapter trimming"
HOMEPAGE="http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/"
SRC_URI="http://www.bioinformatics.babraham.ac.uk/projects/trim_galore/trim_galore_v0.3.3.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="
	sci-biology/cutadapt
	sci-biology/fastqc
	${DEPEND}"
