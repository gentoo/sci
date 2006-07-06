# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_P=epstk21m
MY_DIR=/usr/share/octave/site/m/${PN}

DESCRIPTION="Graphical output functions for Matlab and Octave"
HOMEPAGE="http://www.epstk.de"
SRC_URI="http://epstk.sourceforge.net/down/${MY_P}.zip"

LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE=""

DEPEND="sci-mathematics/octave
	app-text/gv
	app-text/ghostscript-esp"

src_unpack () {
	unpack ${A}
	epatch ${FILESDIR}/octave-epstk-2.1_PATCH1.patch
}

src_install () {
	dodir ${MY_DIR}
	cd ${WORKDIR}/epstk21/m
	insinto ${MY_DIR}
	doins *
	cd ${WORKDIR}/epstk21/
	dodoc License.txt
}

pkg_postinst () {
	einfo "Package installed as octave-epstk."
	einfo "To test epstk, run octave and execute the demo m files."
	einfo "For example:"
	einfo "octave:1> edemo1"
}

