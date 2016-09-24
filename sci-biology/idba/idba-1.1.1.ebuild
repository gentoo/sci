# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="De novo De Bruijn graph assembler iteratively using multimple k-mers"
HOMEPAGE="http://i.cs.hku.hk/~alse/hkubrg/projects/idba
	https://code.google.com/archive/p/hku-idba"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hku-idba/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	# Makefile.am also forces '-fopenmp -pthread', do we care?
	find . -name Makefile.in | while read f; do \
		sed -e 's/-Wall -O3//' -i $f || die
	done || die
	default
}

src_install(){
	default
	# https://github.com/loneknightpy/idba/issues/23
	rm "${D}"/usr/bin/scan.py "${D}"/usr/bin/run-unittest.py || die
	rm bin/test bin/*.o bin/Makefile* || die # avoid file collision
	dobin bin/*
}
