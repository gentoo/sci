# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Utilities for variant calling and manipulating VCF and BCF files"
HOMEPAGE="http://www.htslib.org"
SRC_URI="https://github.com/samtools/bcftools/releases/download/"${PV}"/"${P}".tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# compiles bundled sci-libs/htslib-"${PV}" as a static library and links it into binaries
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s@gcc@$(tc-getCC)@" \
		-e 's#prefix      = /usr/local#prefix      = "${EPREFIX}"/usr#' \
		-e "s@CFLAGS   = -g -Wall -Wc++-compat -O2@#CFLAGS   = ${CFLAGS}@" -i Makefile || die

	sed -e "s@gcc@$(tc-getCC)@" \
		-e 's#prefix      = /usr/local#prefix      = "${EPREFIX}"/usr#' \
		-e "s@CFLAGS   = -g -Wall -O2@#CFLAGS   = ${CFLAGS}@" -i htslib-*/Makefile || die
}
