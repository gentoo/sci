# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Utilities for variant calling and manipulating VCF and BCF files"
HOMEPAGE="http://www.htslib.org/bcftools_release_notes"
SRC_URI="http://sourceforge.net/projects/samtools/files/samtools/1.1/bcftools-1.1.tar.bz2"

LICENSE="MIT-GRL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sci-libs/htslib
	dev-lang/perl"
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e 's#prefix      = /usr/local#prefix      = /usr#' \
		-e 's@CFLAGS   = -g -Wall -Wc++-compat -O2@#CFLAGS   = -g -Wall -Wc++-compat -O2@' -i Makefile

	sed -e 's#prefix      = /usr/local#prefix      = /usr#' \
		-e 's@CFLAGS   = -g -Wall -Wc++-compat -O2@#CFLAGS   = -g -Wall -Wc++-compat -O2@' -i htslib-1.1/Makefile
}
