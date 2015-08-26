# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Assembler for metagenomes, genomes and transcriptomes (untested) using parallel MPI"
HOMEPAGE="http://denovoassembler.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/denovoassembler/files/Ray-"${PV}".tar.bz2"

LICENSE="LGPL-3 GPL-3" # both must be agreed
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}
	sys-cluster/osc-mpiexec"

src_prepare(){
	cp -p README.md README
	cp -p README.md RayPlatform/README
}

src_install(){
	dobin Ray
	dolib libRayPlatform.a libRay.a
}
