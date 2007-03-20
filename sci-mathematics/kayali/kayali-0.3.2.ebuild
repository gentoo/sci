# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Qt front-end for Computer Algebra System mainly maxima"
HOMEPAGE="http://kayali.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"
DEPEND=""
RDEPEND="sci-mathematics/maxima
	>=dev-python/PyQt4-4.1
	media-gfx/imagemagick
	>=dev-python/reportlab-2.0
	>=sci-visualization/gnuplot-4.0"

# is a GUI, testing done simply by launching application
# and follow one of the demo
RESTRICT="test"

S=${WORKDIR}/${PN}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	INSTALL_DIR=/usr/share/${PN}
	echo "#! /bin/sh" > kayali
	echo "cd ${INSTALL_DIR}" >> kayali
	echo "exec python -OOt kayali.py $@" >> kayali
	exeinto /usr/bin
	doexe kayali
	dodir ${INSTALL_DIR}
	insinto ${INSTALL_DIR}
	doins *.py *.txt *.in* maximab.bat maxima.g
	doins -r engines icons pdf qt4gui *uic
	doins icons
	make_desktop_entry kayali kayali kayali.svg
	use doc && dohtml html
	dodoc README
}
