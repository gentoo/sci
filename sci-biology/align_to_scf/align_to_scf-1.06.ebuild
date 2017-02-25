# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="View trace information at a given position missing from Roche .ace files"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/align_to_scf-1.06.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare(){
	sed -i "s:^CC :CC=$(tc-getCC) #:" Makefile || die "sed failed"
	sed -i "s:^LD :LD=$(tc-getCC) #:" Makefile || die "sed failed"
	sed -i 's:^CFLAGS.*:CFLAGS+= -D__LINUX__ -Wcast-align:' Makefile || die "sed failed"
	sed -i 's:^LDFLAGS =:#LDFLAGS =:' Makefile || die "sed failed"
}

src_install(){
	dobin align_to_scf
	dodoc "${FILESDIR}"/README
}
