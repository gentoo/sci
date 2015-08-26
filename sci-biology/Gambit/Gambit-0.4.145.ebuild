# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit qt4-r2

DESCRIPTION="Display genomic alignments from BAM files with annotations from BED, GFF, GFF3, VCF formats"
HOMEPAGE="http://code.google.com/p/gambit-viewer/"
SRC_URI="http://gambit-viewer.googlecode.com/files/Gambit_v0.4.145_src.tar.gz
	http://gambit-viewer.googlecode.com/files/GambitDocumentation_v0.4.145.pdf"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	sci-biology/samtools"

S="${WORKDIR}"/Gambit

src_configure() {
	lupdate ${PN}.pro || die
	lrelease ${PN}.pro || die
	eqmake4 ${PN}.pro || die
}

src_install() {
	dobin ${PN} || die
	dodoc "${DISTDIR}"/GambitDocumentation_v0.4.145.pdf
}
