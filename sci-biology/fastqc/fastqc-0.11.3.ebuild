# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 eutils java-ant-2

DESCRIPTION="Quality control FASTA/FASTQ sequence files"
HOMEPAGE="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/"
SRC_URI="http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v"${PV}"_source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/picard
	sci-libs/jhdf5
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
	ant || die
}

src_install(){
	dobin fastqc run_fastqc.bat
	dodoc README.txt RELEASE_NOTES.txt

	# There is no fastqc.jar.  The output from the compilation is the set of
	# .class files (a jar file is just a zip file full of .class files).  All
	# you need to copy out is the contents of the bin subdirectory, the rest of
	# the download you can discard.
	#
	# jbzip2-0.9.jar comes from https://code.google.com/p/jbzip2
	#
	# ignore the sam-1.103.jar and rely on /usr/share/picard/lib/sam.jar from sci-biology/picard
	# The sam-1.103.jar library comes from
	# http://sourceforge.net/projects/picard/files/sam-jdk/.  Note that there is
	# a newer version of this codebase at https://github.com/samtools/htsjdk but
	# that FastQC is NOT yet compatible with the updated API (this will probably
	# happen in a future release).  This library is needed to read SAM/BAM
	# format files.
	# cisd-jhdf5.jar should be provided by sci-libs/jhdf5
}
