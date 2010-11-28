# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="SAM Tools provide various utilities for manipulating alignments in the SAM format"
HOMEPAGE="http://samtools.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/project/samtools/samtools/0.1.7/samtools-0.1.7a.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="zlib"

DEPEND="sys-libs/zlib
		sys-libs/ncurses"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
}

src_prepare() {
	cd ${W} || die
	sed -i -e "s/-g -Wall -O2/${CFLAGS} -fPIC/" "${S}"/Makefile || die
	sed -i -e "s/-g -Wall -O2/${CFLAGS} -fPIC/" "${S}"/misc/Makefile || die
}

src_compile(){
	emake
	emake razip
}

src_install(){
	dobin razip samtools
	for f in md5sum-lite md5fa maq2sam-short maq2sam-long wgsim; do
		dobin misc/$f
	done

	for f in misc/*.pl; do
		dobin $f
	done

	dolib libbam.a

	insinto /usr/include
	doins bam.h bgzf.h sam.h sam_header.h faidx.h bam_maqcns.h glf.h

	mv samtools.txt samtools.1
	doman samtools.1
}
