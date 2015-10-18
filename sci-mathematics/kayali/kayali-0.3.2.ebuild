# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

DESCRIPTION="Qt front-end for Computer Algebra System mainly maxima"
HOMEPAGE="http://kayali.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	sci-mathematics/maxima
	>=dev-python/PyQt4-4.1[${PYTHON_USEDEP}]
	media-gfx/imagemagick
	>=dev-python/reportlab-2.0[${PYTHON_USEDEP}]
	>=sci-visualization/gnuplot-4.0"

# is a GUI, testing done simply by launching application
# and follow one of the demo
RESTRICT="test"

S=${WORKDIR}/${PN}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile() {
	einfo "Nothing to compile"
}

src_install() {
	local INSTALL_DIR="${EPREFIX}"/usr/share/${PN}

	cat >> "${T}"/kayali <<- EOF
	#!${EPREFIX}/bin/sh
	cd ${INSTALL_DIR}
	exec ${EPYTHON} -OOt kayali.py $@
	EOF

	dobin "${T}"/kayali
	insinto ${INSTALL_DIR}
	doins *.py *.txt *.in* maximab.bat maxima.g
	doins -r engines icons pdf qt4gui *uic

	python_optimize ${INSTALL_DIR}

	make_desktop_entry kayali kayali kayali.svg
	use doc && dohtml html/*
	dodoc README
}
