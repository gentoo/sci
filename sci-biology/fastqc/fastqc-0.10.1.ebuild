# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 eutils

DESCRIPTION="Perl-based wrapper around java apps to quality control FASTA/FASTQ sequence files"
HOMEPAGE="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
SRC_URI="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v"${PV}"_source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/picard
	>=virtual/jrei-1.6"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/FastQC

src_install(){
	dobin fastqc
	
	# TODO: need to compile java in uk/ac/babraham/FastQC/
	# and decide whether jbzip2-0.9.jar and sam-1.32.jar are standard java libs and from samtools or whetehr not
}
