# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Whole genome shotgun assembler using phrap (for Sanger-based reads)"
HOMEPAGE="https://sourceforge.net/projects/phusion2"
SRC_URI="https://downloads.sourceforge.net/project/${PN}/${P}.tar.gz"

LICENSE="all-rights-reserved" # temporarily placed value
# from http://genome.cshlp.org/content/13/1/81.full
# Availability
# Phusion is undergoing a rewrite of the code to make this a portable package. It will be made available free of charge to academic sites, but requires licensing for commercial use. For more information please contact the authors.
SLOT="0"
#KEYWORDS="~amd64"
# dependency sci-biology/phrap removed from ::gentoo in f3cfb83adfc5dd1b85d0c9dce5ffbf166b25f4e4
KEYWORDS=""

DEPEND="app-shells/tcsh
	sys-cluster/openmpi"
RDEPEND="${DEPEND}
	sci-biology/phrap
	dev-lang/perl"

# contains bundled ssaha
# file collision with sci-biology/shrimp on /usr/bin/fasta2fastq

S="${WORKDIR}"

src_prepare(){
	default
	rm -f phusion2 *.o
	sed -e 's/^CFLAGS =/# CFLAGS =/' -i Makefile || die
}

src_install(){
	dobin ctgreads.pl phusion2
	dodoc how_to_make_mates
}
