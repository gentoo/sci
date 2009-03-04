# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8.ebuild,v 1.1 2008/08/26 16:33:07 weaver Exp $

inherit toolchain-funcs

DESCRIPTION="Distance Based OTU and Richness Determination"
HOMEPAGE="http://schloss.micro.umass.edu/software/dotur.html"
SRC_URI="http://schloss.micro.umass.edu/software/${PN}/${P}.tgz"

LICENSE="as-is"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/DOTUR-${PV}"

src_compile() {
	sed -i '/using namespace/ s/$/\n#include <string.h>\n#include <algorithm>/' dotur.C
	$(tc-getCXX) ${CXXFLAGS} -O3 dotur.C -o dotur || die
}

src_install() {
	dobin dotur || die
	dodoc README
}
