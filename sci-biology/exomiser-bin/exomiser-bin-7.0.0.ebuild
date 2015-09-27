# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Annotate VCF files from whole-exome sequencing (Jannovar, UCSC KnownGenes, hg19)"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/exomiser"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/exomiser-cli-${PV}.BETA-distribution.zip"
# 1.16GB !

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/Jannovar-bin"
RDEPEND="${DEPEND}"

pkg_postinst(){
	einfo "Please download 3.7GB file from ftp://ftp.sanger.ac.uk/pub/resources/software/exomiser/downloads/exomiser/h2_db_dumps/exomiser-${PV}.BETA.h2.db.gz"
	einfo "and follow README.md"
}
