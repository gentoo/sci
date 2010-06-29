# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"

inherit multilib python

MY_P="FreeCAD-${PV}"

DESCRIPTION="QT based Computer Aided Design Application"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/free-cad/"
SRC_URI="mirror://sourceforge/free-cad/${MY_P}-2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sci-libs/opencascade
	x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	x11-libs/qt-webkit:4
	=media-libs/coin-3.1.2
	sci-libs/gts
	sys-libs/zlib
	dev-libs/boost
	dev-python/PyQt4
	dev-libs/xerces-c
	=media-libs/SoQt-1.4.2_alpha1841"
DEPEND="${RDEPEND}
	dev-lang/swig"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	python_set_active_version 2
}

src_configure () {
	 econf \
		--with-qt4-include="${EPREFIX}"/usr/include/qt4 \
		--with-qt4-bin="${EPREFIX}"//usr/bin \
		--with-qt4-lib="${EPREFIX}"//usr/$(get_libdir)/qt4
}

src_install () {
	emake  DESTDIR="${D}" install || die "install failed"
	dodoc README.Linux ChangeLog.txt || die
}
