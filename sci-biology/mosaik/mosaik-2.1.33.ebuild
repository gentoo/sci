# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mosaik/mosaik-1.0.1388.ebuild,v 1.1 2010/04/11 17:29:40 weaver Exp $

EAPI="2"

DESCRIPTION="A reference-guided aligner for next-generation sequencing technologies"
HOMEPAGE="http://code.google.com/p/mosaik-aligner/"
SRC_URI="http://mosaik-aligner.googlecode.com/files/MOSAIK-${PV}-source.tar"

LICENSE="GPL-2 || ( MIT )"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/MOSAIK-${PV}-source"

src_prepare() {
	#sed -i 's/-static//' src/includes/linux.inc || die
	echo
}

src_compile() {
	emake || die
#	emake -C MosaikTools/c++ || die
#	emake -C MosaikTools/perl || die
}

src_install() {
	dobin bin/* || die

	insinto /usr/share/${PN}
	doins -r MosaikTools || die

	dodoc README Mosaik-1.0-Documentation.pdf
}
