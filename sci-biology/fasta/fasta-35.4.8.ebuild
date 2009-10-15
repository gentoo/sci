# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="FASTA is a DNA and Protein sequence alignment software package"
HOMEPAGE="http://fasta.bioch.virginia.edu/fasta_www2/fasta_down.shtml"
SRC_URI="http://faculty.virginia.edu/wrpearson/${PN}/${PN}3/${P}.tar.gz"

LICENSE="fasta"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug icc sse2"

DEPEND="icc? ( dev-lang/icc )"
RDEPEND=""

CC_ALT=
CFLAGS_ALT=
ALT=

if use debug ; then
	CFLAGS_ALT=-g -DDEBUG
fi

if use icc ; then
	CC_ALT=icc
	ALT="${ALT}_icc"
else
	CC_ALT=gcc
fi

if use sse2 ; then
	ALT="${ALT}_sse2"
	CFLAGS_ALT="${CFLAGS_ALT} -msse2"
	if ! use icc ; then
		CFLAGS_ALT="${CFLAGS_ALT} -ffast-math"
	fi
fi

src_compile() {
	einfo "Using $CC_ALT compiler"
#	cd src
	make -f make/Makefile.linux${ALT} CC="${CC_ALT} ${CFLAGS}" all
}

src_install() {
	dodir /usr/bin
	make -f Makefile.linux${ALT} CC="${CC_ALT} ${CFLAGS}" XDIR="${D}/usr/bin" install
	doman fasta3.1  fasta35.1  fastf3.1  fasts3.1  map_db.1  prss3.1  ps_lav.1 pvcomp.1
	dodoc COPYRIGHT FASTA_LIST README README.versions fasta20.doc
	dohtml changes_v34.html changes_v35.html search.html
}
