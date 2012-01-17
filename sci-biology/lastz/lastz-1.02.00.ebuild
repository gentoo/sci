# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="A pairwise DNA sequence aligner (also chromosome to chromosome), a BLASTZ replacement"
HOMEPAGE="http://www.bx.psu.edu/~rsharris/lastz/"
SRC_URI="http://www.bx.psu.edu/miller_lab/dist/lastz-"${PV}".tar.gz
		http://www.bx.psu.edu/miller_lab/dist/lav_format.html"

LICENSE=""
SLOT="0"
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/lastz-distrib-"${PV}"

src_install(){
	dobin src/lastz src/lastz_D
	dodoc README.lastz.html
	dodoc "${DISTDIR}"/lav_format.html
}
