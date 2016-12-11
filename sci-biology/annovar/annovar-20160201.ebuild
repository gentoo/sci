# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Annotate variation data in input VCF files"
HOMEPAGE="http://annovar.openbioinformatics.org"
SRC_URI="annovar-20160201.tar.gz
	annovar-20160201_table_annovar.pl"

LICENSE="annovar_personal_only"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="dev-lang/perl
	${DEPEND}"

RESTRICT="fetch"

S="${WORKDIR}"/"${PN}"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and obtain the file"
	einfo "\"${P}.tar.gz\" and place it in ${DISTDIR}."
	einfo "Also fetch an updated version of http://www.openbioinformatics.org/annovar/download/table_annovar.pl"
	einfo "and place it into ${DISTDIR} as ${P}__table_annovar.pl."
}

src_install(){
	dobin *.pl
	# install a "patch" from table_annovar.pl
	newbin "${DISTDIR}"/${P}_table_annovar.pl table_annovar.pl
	insinto /usr/share/"${PN}"
	doins -r example humandb
}
