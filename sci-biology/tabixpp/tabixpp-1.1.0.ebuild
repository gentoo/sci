# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib

DESCRIPTION="C++ wrapper to tabix indexer "
HOMEPAGE="https://github.com/ekg/tabixpp"
SRC_URI="https://github.com/ekg/tabixpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sci-biology/samtools:0"
RDEPEND="${DEPEND}"

src_prepare(){
	default
	sed -e 's@HTS_HEADERS?=	htslib/htslib/bgzf.h htslib/htslib/tbx.h@HTS_HEADERS?=	/usr/include/htslib/bgzf.h /usr/include/htslib/tbx.h@g' -i Makefile || die
	sed -e 's@HTS_LIB?=	htslib/libhts.a@HTS_LIB?=	/usr/'"$(get_libdir)"'/libhts.so@g' -i Makefile || die
}

src_install() {
	einstalldocs
	dobin tabix++
	doheader tabix.hpp
}
