# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="Short read aligner, K-mer-based error-correct and normalize, FASTA/Q tool"
HOMEPAGE="https://sourceforge.net/projects/bbmap/"
SRC_URI="https://sourceforge.net/projects/bbmap/files/BBMap_${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	sys-cluster/openmpi[java(-)]
	>=virtual/jdk-1.7:*
	dev-java/ant-core"
RDEPEND="${DEPEND}
	>=virtual/jre-1.7:*"

S="${WORKDIR}/bbmap"

src_prepare(){
	default
	# fix the line in build.xml to point to mpi.jar location
	# <property name="mpijar" location="/tmp/mpi.jar" ></property>
	# see bug #542700
	sed -e 's#/usr/common/usg/hpc/openmpi/gnu4.6/sge/1.8.1/ib_2.1-1.0.0/lib/mpi.jar#/usr/share/openmpi/lib/mpi.jar#' -i build.xml
	sed -e 's#compiler="${jcompiler}" ##' -i build.xml
}

src_compile(){
	eant dist
}

src_install(){
	dobin *.sh
	dodoc docs/readme.txt
	java-pkg_dojar dist/lib/BBTools.jar
}
