# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/kseg/kseg-0.402.ebuild,v 1.1 2006/01/14 17:14:18 cryos Exp $

inherit eutils qt3

DESCRIPTION="Interactive geometry program for exploring Euclidean geometry"
HOMEPAGE="http://www.mit.edu/~ibaran/kseg.html"
SRC_URI="http://www.mit.edu/~ibaran/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"
DEPEND="$(qt_min_version 3.3)"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix silly hardcoded help file path and CCFLAGS.
	epatch ${FILESDIR}/${P}-gentoo.patch
	sed -i -e "s|KSEG_HELP_DIR|${PF}/help|" main.cpp
}

src_install() {
	exeinto /usr/bin
	doexe kseg
	dodoc AUTHORS ChangeLog README README.translators VERSION
	insinto /usr/share/doc/${PF}/help
	doins *.html *.qm
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
