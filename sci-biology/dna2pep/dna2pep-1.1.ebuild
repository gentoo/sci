# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Translate DNA sequence into protein (with STOP codon read-through)"
HOMEPAGE="http://www.cbs.dtu.dk/services/VirtualRibosome/download.php"
SRC_URI="http://www.cbs.dtu.dk/services/VirtualRibosome/releases/${P}.tgz"

# source code does not explictly mention GPL version so I assume GPL-1
LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e 's@#!/usr/local/python/bin/python@#! /usr/bin/env python@' -i *.py || die
}

src_install(){
	dobin *.py
	insinto /usr/share/"${PN}"/
	doins mtx/gcMitVertebrate.mtx
}
