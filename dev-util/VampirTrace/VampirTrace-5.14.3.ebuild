# Copyright 2013-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="VampirTrace is an open source library that allows detailed logging of program execution for parallel applications."
HOMEPAGE="http://www.tu-dresden.de/die_tu_dresden/zentrale_einrichtungen/zih/forschung/software_werkzeuge_zur_unterstuetzung_von_programmierung_und_optimierung/vampirtrace"
SRC_URI="http://wwwpub.zih.tu-dresden.de/%7Emlieber/dcount/dcount.php?package=vampirtrace&get=${P}.tar.gz"

SLOT="0"
LICENSE="vampir"
KEYWORDS="~amd64"
IUSE="cuda"

RDEPEND="virtual/mpi"

src_configure() {
	use cuda && myconf="--with-cuda-dir=/opt/cuda"
	econf $myconf
}

src_install() {
	default
	# avoid collisions with app-text/lcdf-typetools:
	mv ${D}/usr/bin/otfinfo ${D}/usr/bin/otfinfo.vampir
	md ${D}/usr/lib/debug/usr/bin/otfinfo.debug ${D}/usr/lib/debug/usr/bin/otfinfo.vampir.debug
	# libtool is already installed:
	rm ${D}/usr/share/libtool
}
