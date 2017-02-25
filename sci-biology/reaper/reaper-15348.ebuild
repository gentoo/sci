# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PV="15-348"

DESCRIPTION="Demultiplex, trim 3'-adapter/polyA and filter short read DNA sequences"
HOMEPAGE="http://www.ebi.ac.uk/~stijn/reaper"
SRC_URI="http://www.ebi.ac.uk/~stijn/reaper/src/${PN}-${MY_PV}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"-"${MY_PV}"/src

src_prepare(){
	sed -e 's/ -O3 / ${CFLAGS} /' -i Makefile || die
}

src_compile(){
	emake
}

src_install(){
	dobin reaper tally minion swan
	dodoc ../doc/*.html
}
