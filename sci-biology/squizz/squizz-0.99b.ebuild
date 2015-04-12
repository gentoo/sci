# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Sequence format file checker/converter."
HOMEPAGE="ftp://ftp.pasteur.fr/pub/GenSoft/projects/squizz/README"
SRC_URI="ftp://ftp.pasteur.fr/pub/gensoft/projects/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_test(){
	einfo ">>> Test phase [check]: ${CATEGORY}/${PF}"
	emake  -j1 check
}
