# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils
# eclasses tend to list descriptions of how to use their functions properly.
# take a look at /usr/portage/eclasses/ for more examples.

DESCRIPTION="A KDE based Computer Algebra System (CAS) Frontend for Maxima and Gnuplot."
HOMEPAGE="http://kayali.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

#The source code does not state any licence. 
#Upstream was emailed for this issue
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE="plotting"
DEPEND=""
RDEPEND="virtual/python
	sci-mathematics/maxima
	dev-python/PyQt
	plotting? ( >sci-visualization/gnuplot-4.0
	media-libs/gd )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A} || die
	epatch ${FILESDIR}/${P}-calcwindow.patch || die
}

src_compile() {
	einfo "There is nothing to compile"
}

src_install() {
	dodir /usr/share/kayali /usr/bin || die "Unable to create directories"
	insinto /usr/share/kayali || die
	doins * || die "doins failed"
	fperms 755 /usr/share/kayali/kayali.py || die
	dosym /usr/share/kayali/kayali.py /usr/bin/kayali || die
	doicon kayali.png || die
	domenu ${FILESDIR}/kayali.desktop || die
}
