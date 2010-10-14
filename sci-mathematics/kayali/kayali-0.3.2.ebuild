# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"

inherit eutils python

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

pkg_setup() {
	python_set_active_version 2
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	INSTALL_DIR="${EPREFIX}"/usr/share/${PN}
	cat >> "${T}"/kayali <<- EOF
	#!${EPREFIX}/bin/sh
	cd ${INSTALL_DIR}
	exec $(PYTHON) -OOt kayali.py $@
	EOF
	dobin "${T}"/kayali || die
	insinto ${INSTALL_DIR}
	doins *.py *.txt *.in* maximab.bat maxima.g || die
	doins -r engines icons pdf qt4gui *uic || die
	make_desktop_entry kayali kayali kayali.svg
	if use doc; then
		dohtml html/* || die
	fi
	dodoc README || die
}
