# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A tool to map bisulfite converted sequence reads and determine cytosine methylation states"
HOMEPAGE="http://www.bioinformatics.babraham.ac.uk/projects/bismark/"
SRC_URI="http://www.bioinformatics.babraham.ac.uk/projects/${PN}/${PN}_v${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc"

DEPEND=""
RDEPEND="sci-biology/bowtie"

S="${WORKDIR}/${PN}_v${PV}"

src_install() {
	dobin bismark{,2bedGraph,2report,_genome_preparation,_methylation_extractor} coverage2cytosine deduplicate_bismark
	insinto /usr/share/${P}
	doins bismark_sitrep.tpl
	dosym /usr/share/${P}/bismark_sitrep.tpl /usr/bin/bismark_sitrep.tpl
	if use doc; then
		dodoc Bismark_User_Guide.pdf RRBS_Guide.pdf license.txt RELEASE_NOTES.txt
	fi
}
