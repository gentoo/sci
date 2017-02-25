# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="DNA read mapper using k=20 (successor of ssaha2)"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/smalt/"
SRC_URI="http://sourceforge.net/projects/${PN}/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
# TODO: add https://github.com/gt1/bambamc dependency
# ./configure --with-bambamc=yes BAMBAMC_CFLAGS="-I$BAMBAMC_INSTALL_DIR/include" BAMBAMC_LIBS="-L$BAMBAMC_INSTALL_DIR/lib -lbambamc"
#
# but NEWS states
# - Ammended installation instructions with the bambamc library.

S="${WORKDIR}"/${MY_P}

src_install(){
	dobin src/smalt
	insinto /usr/share/"${PN}"
	doins misc/*.py
	dodoc README NEWS
}
# is the tarball with source code lacking the manual? Upstream contacted.
#	dodoc NEWS ${MY_PN}_manual.pdf
#	doman ${MY_PN}.1
