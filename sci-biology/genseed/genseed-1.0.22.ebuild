# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Seed-driven progressive assembly program using legacy NCBI blast, CAP3, and optionally cross_match"
HOMEPAGE="http://www.coccidia.icb.usp.br/genseed/"
SRC_URI="http://www.coccidia.icb.usp.br/genseed/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	sci-biology/cap3-bin
	dev-lang/perl
	sci-biology/ncbi-tools"
RDEPEND=""

S="${WORKDIR}"

src_install() {
	newbin ${PN}.pl ${PN}
}

pkg_postinst(){
	einfo "Ideally install also sci-biology/phrap which provides cross_match"
	einfo "It is used for vector masking"
}
