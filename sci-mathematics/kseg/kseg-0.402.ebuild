# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Interactive geometry program for exploring Euclidean geometry."
HOMEPAGE="http://www.mit.edu/~ibaran/kseg.html"
SRC_URI="http://www.mit.edu/~ibaran/${P}.tar.gz" 
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND=">=x11-libs/qt-3.0.0"

src_unpack() {
	unpack ${A}
	cd ${S}
	# Fix silly hardcoded help file path and CCFLAGS.
	# The help location has to be changed when changing
	# version. It is allways /usr/share/doc/${PF}/help
	epatch ${FILESDIR}/${PF}-gentoo.patch
}

src_install() {
	exeinto /usr/bin
	doexe kseg
	dodoc AUTHORS ChangeLog README README.translators VERSION
	insinto /usr/share/doc/${PF}/help
	doins *.html *.qm
	insinto /usr/share/doc/${PF}/examples
	doins examples/*
}
