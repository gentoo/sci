# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Merge-sort utility for compressed alignment files, with multi-file output"
HOMEPAGE="http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz -> ${P}.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/gclib.tar.gz -> gclib-${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-build.patch )

src_configure() {
	tc-export CC CXX
}

src_install() {
	dobin ${PN}
	einstalldocs
}
