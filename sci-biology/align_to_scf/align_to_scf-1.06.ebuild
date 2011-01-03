# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="This is used by sci-biology/roche454ace2caf.pl"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/align_to_scf-1.06.tgz"

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
	dobin align_to_scf || die
}
