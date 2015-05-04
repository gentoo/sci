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
KEYWORDS=""
IUSE=""

# needs USE=java, see bug #542700
DEPEND="
	sys-cluster/openmpi[java]
	>=virtual/jdk-1.7:*
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}"/bbmap

#src_prepare(){
#	# fix the line in build.xml to point to mpi.jar location
#	# <property name="mpijar" location="/tmp/mpi.jar" ></property>
#}

src_compile(){
	ant dist || die
}

src_install(){
	dobin *.sh
	dodoc docs/readme.txt
	java-pkg_dojar dist/lib/BBTools.jar
}
