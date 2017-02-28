# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="View trace information at a given position missing from Roche .ace files"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/align_to_scf-1.06.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare(){
	sed \
		-e "s:^CC :CC=$(tc-getCC) #:" \
		-e "s:^LD :LD=$(tc-getCC) #:" \
		-e 's:^CFLAGS.*:CFLAGS+= -D__LINUX__ -Wcast-align:' \
		-e 's:^LDFLAGS =:#LDFLAGS =:' \
		-i Makefile || die "sed failed"
	default
}

src_install(){
	dobin align_to_scf
	dodoc "${FILESDIR}"/README
}
