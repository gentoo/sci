# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/ncbi-tools++/ncbi-tools++-2009.05.15-r1.ebuild,v 1.2 2009/08/19 08:00:26 weaver Exp $

EAPI="2"

inherit base toolchain-funcs

DESCRIPTION="Population genetics analysis"
HOMEPAGE="http://genepop.curtin.edu.au/ http://kimura.univ-montp2.fr/~rousset/Genepop.htm"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="CeCILL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	base_src_unpack
	unzip -d "${S}" sources.zip
	mkdir "${S}/examples"
	unzip -d "${S}/examples" examples.zip
}

src_compile() {
	$(tc-getCXX) ${CFLAGS} -DNO_MODULES -o Genepop GenepopS.cpp -O3 || die
}

src_install() {
	dobin Genepop || die
	insinto /usr/share/${PN}
	doins -r examples || die
	dodoc Genepop.pdf
}
