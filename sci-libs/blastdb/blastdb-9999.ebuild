# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="The BLAST NR database"
HOMEPAGE="http://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=ProgSelectionGuide"
SRC_URI=""

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
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
