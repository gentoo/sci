# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Short read aligner, K-mer-based error-correction and normalization, FASTA/Q conversion"
HOMEPAGE="http://sourceforge.net/projects/bbmap/"
SRC_URI="http://sourceforge.net/projects/bbmap/files/BBMap_"${PV}".tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=virtual/jdk-1.7:*
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}"/bbmap

src_compile(){
	ant compile || die
}

src_install(){
	dobin *.sh
	dodoc docs/readme.txt
	java-pkg_dojar lib/BBTools.jar
}
