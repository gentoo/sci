# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit java-pkg-2 java-ant-2

DESCRIPTION="Short read aligner, K-mer-based error-correct and normalize, FASTA/Q tool"
HOMEPAGE="http://sourceforge.net/projects/bbmap/"
SRC_URI="http://sourceforge.net/projects/bbmap/files/BBMap_"${PV}".tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	sys-cluster/openmpi[java]
	>=virtual/jdk-1.7:*
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}"/bbmap

src_prepare(){
	# fix the line in build.xml to point to mpi.jar location
	# <property name="mpijar" location="/tmp/mpi.jar" ></property>
	# see bug #542700
	sed -e 's#/usr/common/usg/hpc/openmpi/gnu4.6/sge/1.8.1/ib_2.1-1.0.0/lib/mpi.jar#/usr/share/openmpi/lib/mpi.jar#' -i build.xml
	sed -e 's#compiler="${jcompiler}" ##' -i build.xml
	epatch "${FILESDIR}"/UnicodeToAscii.patch
}

src_compile(){
	ant dist || die
}

src_install(){
	dobin *.sh
	dodoc docs/readme.txt
	java-pkg_dojar dist/lib/BBTools.jar
}
