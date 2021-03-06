# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Containment clustering and layout utility for processing pairwise alignments"
HOMEPAGE="https://web.archive.org/web/20140726030702/http://compbio.dfci.harvard.edu/tgi/software/"
SRC_URI="
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/${PN}.tar.gz -> ${P}.tar.gz
	ftp://occams.dfci.harvard.edu/pub/bio/tgi/software/tgicl/gclib.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${PV}-build.patch"
)

src_prepare() {
	default
	tc-export CXX
}

src_install() {
	dobin ${PN}
	dodoc README
}
