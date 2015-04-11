# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="squizz is a sequence format file checker/converter."
HOMEPAGE="ftp://ftp.pasteur.fr/pub/GenSoft/projects/squizz/README"
SRC_URI="ftp://ftp.pasteur.fr/pub/gensoft/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure(){
	econf
}

src_compile() {
	emake
}

src_test(){
	einfo ">>> Test phase [check]: ${CATEGORY}/${PF}"
	make  -j1 check || die "test failed"
}

src_install() {
	emake DESTDIR="${D}" install
}
