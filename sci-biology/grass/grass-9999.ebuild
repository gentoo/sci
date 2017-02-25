# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3 eutils

DESCRIPTION="Scaffold next-generation sequencing assemblies"
HOMEPAGE="https://github.com/AlexeyG/GRASS"
#SRC_URI="https://github.com/AlexeyG/GRASS/archive/master.zip -> grass-20130628.zip
#	https://tud-scaffolding.googlecode.com/files/GRASS%20manual.pdf -> grass_manual.pdf"
EGIT_REPO_URI="https://github.com/AlexeyG/GRASS.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# some IBM development CPLEX library?
# ilcplex/ilocplex.h: No such file or directory
# https://github.com/AlexeyG/GRASS/issues/6
DEPEND="sci-biology/bamtools
	sci-biology/ncbi-tools++
	sys-cluster/openmpi"
RDEPEND="${DEPEND}"

src_prepare(){
	epatch "${FILESDIR}"/fix_Makefile_variablenames.patch
#	sed -e 's#/data/bio/alexeygritsenk/apps/include/ncbi-tools++#/usr/include/ncbi-tools++#' -i Makefile.config || die
#	sed -e 's#/data/bio/alexeygritsenk/apps/include/#/usr/include/bamtools#' -i Makefile.config || die
#	sed -e 's#/data/bio/alexeygritsenk/apps/lib#/usr/lib64#' -i Makefile.config || die
}

src_compile(){
	emake all
}

src_install(){
	newdoc manual/manual.pdf grass_manual.pdf
	dobin bin/*
}
