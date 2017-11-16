# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A pairwise DNA sequence aligner, a BLASTZ replacement"
HOMEPAGE="http://www.bx.psu.edu/~rsharris/lastz/"
SRC_URI="http://www.bx.psu.edu/~rsharris/lastz/newer/${P}.tar.gz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/lastz-distrib-"${PV}"

RESTRICT="mirror"

src_prepare() {
	append-lfs-flags
	epatch "${FILESDIR}"/${P}-build.patch

	tc-export CC
}

src_compile(){
	emake
	emake lastz_32
}

src_install(){
	emake install
	emake install_32
	dobin src/lastz src/lastz_D src/lastz_32
	dodoc README.lastz.html
	dohtml lav_format.html
}
