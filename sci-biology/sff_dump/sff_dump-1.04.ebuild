# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Convert Roche SFF files to FASTA file format"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/${P}.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare(){
	sed \
		-e 's:^CC :#CC :' \
		-e 's:^LD :#LD :' \
		-e 's:^CFLAGS.*:CFLAGS+= -D__LINUX__ -Wcast-align:' \
		-e 's:^LDFLAGS=:#LDFLAGS=:' \
		-i Makefile || die
	tc-export CC LD
}

src_install(){
	dobin sff_dump
}
