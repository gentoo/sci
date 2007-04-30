# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs

DESCRIPTION="The BLAST-Like Alignment Tool, a fast genomic sequence aligner"
LICENSE="blat"
HOMEPAGE="http://www.cse.ucsc.edu/~kent/"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

SRC_URI="http://www.soe.ucsc.edu/~kent/src/${PN}Src${PV}.zip"
S="${WORKDIR}/${PN}Src"

DEPEND="app-arch/unzip"
RDEPEND=""

src_compile() {
	MACHTYPE=$(tc-arch)
	if [[ $MACHTYPE == "x86" ]]; then MACHTYPE="i386"; fi
	sed -i 's/-Werror//; s/CFLAGS=//;' "${S}/inc/common.mk"
	sed -i 's/\(${STRIP} \)/#\1/' "${S}"/{*/makefile,utils/*/makefile,*/*.mk}
	mkdir -p "${S}/bin/${MACHTYPE}"
	emake MACHTYPE="${MACHTYPE}" HOME="${S}" || die "emake failed"
}

src_install() {
	MACHTYPE=$(tc-arch)
	if [[ $MACHTYPE == "x86" ]]; then MACHTYPE="i386"; fi
	dobin "${S}/bin/${MACHTYPE}/"*
}
