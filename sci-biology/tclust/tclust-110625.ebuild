# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Transitive closure clustering tool with overlap filtering options"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz -> ${P}.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/gclib.tar.gz -> gclib-${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	tc-export CC CXX
}

src_install() {
	dobin ${PN}
	dodoc README
}
