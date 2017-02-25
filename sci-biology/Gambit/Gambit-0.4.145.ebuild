# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="Genomic alignments from BAM files"
HOMEPAGE="http://code.google.com/p/gambit-viewer/"
SRC_URI="
	http://gambit-viewer.googlecode.com/files/Gambit_v0.4.145_src.tar.gz
	doc? ( http://gambit-viewer.googlecode.com/files/GambitDocumentation_v0.4.145.pdf )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
RDEPEND="${DEPEND}
	sci-biology/samtools"

S="${WORKDIR}"/Gambit

src_configure() {
	$(qt4_get_bindir)/lupdate ${PN}.pro || die
	$(qt4_get_bindir)/lrelease ${PN}.pro || die
	eqmake4 ${PN}.pro
}

src_install() {
	dobin ${PN}
	use doc && dodoc "${DISTDIR}"/GambitDocumentation_v0.4.145.pdf
}
