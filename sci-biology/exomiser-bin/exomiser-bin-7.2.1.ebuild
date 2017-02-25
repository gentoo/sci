# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Annotate VCF files and prioritize genome/exome mutations"
HOMEPAGE="http://www.sanger.ac.uk/science/tools/exomiser"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/exomiser-cli-${PV}-distribution.zip
	ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/GenomiserREADME -> ${PN}.README
	ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/README.md -> ${PN}.README.md"
# 1.16GB !

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/Jannovar-bin"
RDEPEND="${DEPEND}"

src_install(){
	dodoc "${DISTDIR}"/${PN}.README "${DISTDIR}"/${PN}.README.md
}

pkg_postinst(){
	einfo "Please download 3.7GB file from ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/h2_db_dumps/exomiser-${PV}.BETA.h2.db.gz"
	einfo "and follow README.md"
	einfo "The is also 19GB file ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/exomiser-cli-7.2.1-data.zip"
	einfo "with test data"
}
