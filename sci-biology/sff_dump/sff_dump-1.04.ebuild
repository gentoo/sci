# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Convert Roche SFF files to FASTA file format (alternative to sffdump from Roche and sff_extract from mira)"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/sff_dump-1.04.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -i 's:^CC :#CC :' Makefile
	sed -i 's:^LD :#LD :' Makefile
	sed -i 's:^CFLAGS.*:CFLAGS+= -D__LINUX__ -Wcast-align:' Makefile
	sed -i 's:^LDFLAGS=:#LDFLAGS=:' Makefile
}

src_install(){
	dobin sff_dump || die
}
