# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mosaik/mosaik-1.0.1388.ebuild,v 1.1 2010/04/11 17:29:40 weaver Exp $

EAPI=5

DESCRIPTION="A reference-guided aligner for next-generation sequencing technologies"
HOMEPAGE="http://code.google.com/p/mosaik-aligner/"
SRC_URI="
	http://mosaik-aligner.googlecode.com/files/MOSAIK-${PV}-source.tar
	http://code.google.com/p/mosaik-aligner/downloads/detail?name=Mosaik%201.0%20Documentation.pdf -> Mosaik-1.0-Documentation.pdf"

LICENSE="GPL-2 || ( MIT )"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/MOSAIK-${PV}-source

src_install() {
	dobin "${WORKDIR}"/bin/*

	dodoc README "${DISTDIR}"/Mosaik-1.0-Documentation.pdf
}
