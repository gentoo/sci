# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="View trace information at a given position missing from Roche .ace files"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/align_to_scf-${PV}.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare(){
	default
	sed -i 's:^CFLAGS.*:CFLAGS+= -D__LINUX__ -Wcast-align:' Makefile || die "sed failed"
	sed -i 's:^LDFLAGS =:#LDFLAGS =:' Makefile || die "sed failed"
}

src_install(){
	dobin align_to_scf
	dodoc "${FILESDIR}"/README
}
