# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/qwt/qwt-5.2.0.ebuild,v 1.1 2009/04/07 18:18:00 bicatali Exp $

EAPI=2
inherit eutils qt4

DESCRIPTION="2D plotting library for Qt4"
HOMEPAGE="http://qwt.sourceforge.net/"
#SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
SRC_URI="http://dev.gentooexperimental.org/~jlec/distfiles/${P}.tar.bz2"

LICENSE="qwt"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="5"
IUSE="doc examples svg"

DEPEND="x11-libs/qt-gui:4
	svg? ( x11-libs/qt-svg:4 )"
RDEPEND="${DEPEND}"

src_prepare() {
	cat > qwtconfig.pri <<-EOF
		target.path = /usr/$(get_libdir)
		headers.path = /usr/include/qwt5
		doc.path = /usr/share/doc/${PF}
		CONFIG += qt warn_on thread release
		CONFIG += QwtDll QwtPlot QwtWidgets QwtDesigner
		VERSION = ${PV}
	EOF
	# don't build examples - fix the qt files to build once installed
	cat > examples/examples.pri <<-EOF
		include( qwtconfig.pri )
		TEMPLATE     = app
		MOC_DIR      = moc
		INCLUDEPATH += /usr/include/qwt5
		DEPENDPATH  += /usr/include/qwt5
		LIBS        += -lqwt
	EOF
	sed -i -e 's:../qwtconfig:qwtconfig:' examples/examples.pro || die
	sed -i -e 's/headers doc/headers/' src/src.pro || die
	qt4_src_prepare
}

src_configure() {
	use svg && echo >> qwtconfig.pri "CONFIG += QwtSVGItem"
	cp qwtconfig.pri examples/qwtconfig.pri
	eqmake4
}
src_compile() {
	# split compilation to allow parallel building
	emake sub-src || die "emake library failed"
	emake || die "emake failed"
}

src_install () {
	emake INSTALL_ROOT="${D}" install || die "emake install failed"
	dodoc CHANGES README
	insinto /usr/share/doc/${PF}
	if use doc; then
		doman doc/man/*/* || die
		doins -r doc/html || die
	fi
	if use examples; then
		doins -r examples || die
	fi
}
