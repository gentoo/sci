# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Assembler for metagenomes, genomes and transcriptomes using MPI"
HOMEPAGE="http://denovoassembler.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/denovoassembler/files/Ray-"${PV}".tar.bz2"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="virtual/mpi"
RDEPEND="${DEPEND}
	sys-cluster/osc-mpiexec"

src_install(){
	dobin Ray
	use static-libs && dolib.a libRayPlatform.a libRay.a
}
