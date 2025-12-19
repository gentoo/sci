# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A pairwise DNA sequence aligner, a BLASTZ replacement"
HOMEPAGE="http://www.bx.psu.edu/~rsharris/lastz/"
SRC_URI="http://www.bx.psu.edu/~rsharris/lastz/newer/${P}.tar.gz"

SLOT="0"
LICENSE="all-rights-reserved"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/lastz-distrib-"${PV}"

RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default
	append-lfs-flags

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
	dodoc README.lastz.html lav_format.html
}
