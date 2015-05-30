# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Perl-based wrapper around java apps to quality control FASTA/FASTQ sequence files"
HOMEPAGE="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
SRC_URI="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v"${PV}"_source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/picard
	>=virtual/jre-1.5:*"
RDEPEND="${DEPEND}
	dev-lang/perl
	>=virtual/jdk-1.5:*
	dev-java/ant-core"

S="${WORKDIR}"/FastQC

src_prepare(){
	cp "${FILESDIR}"/build.xml . || die
}

src_compile(){
	ant build || die # TODO: this does not work somehow
}

src_install(){
	dobin fastqc run_fastqc.bat
	dodoc README.txt RELEASE_NOTES.txt

	# TODO: need to compile java in uk/ac/babraham/FastQC/
	# and decide whether jbzip2-0.9.jar is a standard java lib or not
	# ignore the sam-1.103.jar, that is likely library already in sci-biology/picard
	# cisd-jhdf5.jar
}
