# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A whole-genome shotgun assembler from TIGR"
HOMEPAGE="http://www.tigr.org/software/assembler/"
SRC_URI="ftp://ftp.tigr.org/pub/software/assembler/TIGR_Assembler_v2.tar.gz"

LICENSE="Artistic"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/TIGR_Assembler_v2"

src_compile() {
	sed -i 's/CFLAGS.*= -O/CFLAGS := -O ${CFLAGS}/' "${S}/src/Makefile" || die "sed failed"
	cd "${S}/src"
	emake || die "emake failed"
}

src_install() {
	dobin bin/{run_TA,TIGR_Assembler}
	dodoc README
}
