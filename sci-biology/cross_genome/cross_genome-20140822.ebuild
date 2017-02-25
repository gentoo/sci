# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Genome scaffolding using cross-species synteny"
HOMEPAGE="http://www.sanger.ac.uk/science/tools/crossgenome"
SRC_URI="https://sourceforge.net/projects/phusion2/files/cross_genome/cross_genome.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

S="${WORKDIR}"

src_prepare(){
	sed -e 's/^CC =/# CC =/' -i Makefile || die
	sed -e 's/^CFLAGS =/# CFLAGS =/' -i Makefile || die
	default
}

src_install(){
	# per upstream cross_genome.csh is not needed
	dobin cross_genome
	dodoc README
}
