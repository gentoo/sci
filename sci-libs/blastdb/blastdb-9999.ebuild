# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="The BLAST NR database"
HOMEPAGE="http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=ProgSelectionGuide"
SRC_URI=""

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="sci-biology/ncbi-tools++"

RESTRICT="binchecks strip"

src_unpack() {
	if [[ -n ${ESLEEP} ]]; then
		elog "Will sleep for ${ESLEEP}"
		sleep ${ESLEEP}
	fi
	update_blastdb.pl --verbose --verbose --decompress nr || die
}
