# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="parallel multi-FASTA file processing tool from TIGR Gene Indices project tools"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_unpack(){
	mkdir ${PN} || die
	cd ${PN} || die "Failed to chdir"
	unpack ${PN}.tar.gz || die
}

src_compile() {
	cd ${PN} || die
	emake || die "emake failed in "${S}"/${PN}"
}

src_install() {
	cd ${PN} || die
	dobin ${PN} || die "Failed to install ${PN} binary"
	newdoc README README.${PN}
}
