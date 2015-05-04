# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mosaik/mosaik-1.0.1388.ebuild,v 1.1 2010/04/11 17:29:40 weaver Exp $

EAPI="2"

if [ "$PV" == "9999" ]; then
	inherit git-2
fi

DESCRIPTION="A reference-guided aligner for next-generation sequencing technologies"
HOMEPAGE="http://code.google.com/p/mosaik-aligner/"

if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="http://code.google.com/p/mosaik-aligner"
	KEYWORDS=""
else
	SRC_URI="http://mosaik-aligner.googlecode.com/files/MOSAIK-${PV}-source.tar
		http://code.google.com/p/mosaik-aligner/downloads/detail?name=Mosaik%201.0%20Documentation.pdf -> Mosaik-1.0-Documentation.pdf"
	#KEYWORDS="~amd64 ~x86"
	KEYWORDS=""
fi

LICENSE="GPL-2 || ( MIT )"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

if [ ! "$PV" == "9999" ]; then
	S="${WORKDIR}/MOSAIK-${PV}-source"
fi

src_compile() {
	if [ "$PV" == "9999" ]; then
		cd src || die
	fi
	emake || die
}

src_install() {
	dobin "${WORKDIR}"/bin/* || die

	dodoc README "${DISTDIR}"/Mosaik-1.0-Documentation.pdf
}
