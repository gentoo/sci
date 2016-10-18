# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="De novo De Bruijn graph assembler iteratively using multimple k-mers"
HOMEPAGE="http://i.cs.hku.hk/~alse/hkubrg/projects/idba_ud"
EGIT_REPO_URI="https://github.com/loneknightpy/idba.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	find . -name Makefile.in | while read f; do \
		sed -e 's/-Wall -O3//' -i $f || die
	done
	default
}

src_install(){
	default
	# https://github.com/loneknightpy/idba/issues/23
	rm "${D}"/usr/bin/scan.py "${D}"/usr/bin/run-unittest.py || die
	rm bin/test bin/*.o bin/Makefile* || die # avoid file collision
	dobin bin/*
}
