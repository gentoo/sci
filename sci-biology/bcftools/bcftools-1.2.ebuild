# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Utilities for variant calling and manipulating VCF and BCF files"
HOMEPAGE="http://www.htslib.org"
SRC_URI="https://github.com/samtools/bcftools/releases/download/"${PV}"/"${P}".tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-libs/htslib
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s@gcc@$(tc-getCC)@" \
		-e 's#prefix      = /usr/local#prefix      = /usr#' \
		-e "s@CFLAGS   = -g -Wall -Wc++-compat -O2@#CFLAGS   = ${CFLAGS}@" -i Makefile || die

	sed -e "s@gcc@$(tc-getCC)@" \
		-e 's#prefix      = /usr/local#prefix      = /usr#' \
		-e "s@CFLAGS   = -g -Wall -O2@#CFLAGS   = ${CFLAGS}@" -i htslib-*/Makefile || die
}
