# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Successor of ssaha2: pairwise sequence alignment mapping DNA reads"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/smalt/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

S="${WORKDIR}"/${MY_P}

src_install(){
	dobin src/smalt
	insinto /usr/share/"${PN}"
	doins misc/*.py
	dodoc README NEWS
}
# is the tarball with source code lacking the manual?
#	dodoc NEWS ${MY_PN}_manual.pdf
#	doman ${MY_PN}.1
