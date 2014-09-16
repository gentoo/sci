# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Short read aligner, K-mer-based error-correction and normalization, FASTA/FASTQ conversion"
HOMEPAGE="http://sourceforge.net/projects/bbmap/"
SRC_URI="http://sourceforge.net/projects/bbmap/files/BBMap_31.40_java7.tar.gz"
#SRC_URI="http://sourceforge.net/projects/bbmap/files/BBMap_31.40_java6.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=virtual/jdk-1.7
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7"

S="${WORKDIR}"/bbmap
