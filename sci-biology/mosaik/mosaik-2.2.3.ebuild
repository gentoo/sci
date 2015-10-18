# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A reference-guided aligner for next-generation sequencing technologies"
HOMEPAGE="http://code.google.com/p/mosaik-aligner/"
SRC_URI="
	http://mosaik-aligner.googlecode.com/files/MOSAIK-${PV}-source.tar
	http://code.google.com/p/mosaik-aligner/downloads/detail?name=Mosaik%201.0%20Documentation.pdf -> Mosaik-1.0-Documentation.pdf"

LICENSE="GPL-2 || ( MIT )"
SLOT="0"
IUSE=""
KEYWORDS=""

# https://code.google.com/p/mosaik-aligner/issues/detail?id=135

S="${WORKDIR}"/MOSAIK-${PV}-source

src_prepare(){
	sed -e "s@export LDFLAGS = -Wl@#export LDFLAGS = -Wl@" -i Makefile
}

src_install() {
	dobin "${WORKDIR}"/bin/*

	dodoc README "${DISTDIR}"/Mosaik-1.0-Documentation.pdf
}
