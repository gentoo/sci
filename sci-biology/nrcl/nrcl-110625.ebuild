# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Containment clustering and layout utility for processing pairwise alignments"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz -> ${P}.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/gclib.tar.gz -> gclib.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-build.patch
	tc-export CXX
}

src_install() {
	dobin ${PN}
	dodoc README
}
