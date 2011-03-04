# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
PYTHON_DEPEND=2

inherit base eutils multilib autotools python

MY_P="freecad-${PV}"
MY_PD="FreeCAD-${PV}"

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="http://sourceforge.net/apps/mediawiki/free-cad/"
SRC_URI="mirror://sourceforge/free-cad/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-cpp/eigen
	dev-games/ode
	dev-libs/boost
	dev-libs/xerces-c
	dev-python/pivy
	dev-python/PyQt4
	media-libs/coin
	media-libs/SoQt
	>=sci-libs/opencascade-6.3-r3
	sci-libs/gts
	sys-devel/gcc[fortran]
	sys-libs/zlib
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-svg:4
	x11-libs/qt-webkit:4
	x11-libs/qt-xmlpatterns:4
"
DEPEND="${RDEPEND}
	dev-lang/swig"

PATCHES=( "${FILESDIR}/${P}-asneeded.patch" )

RESTRICT="bindist mirror"
# http://bugs.gentoo.org/show_bug.cgi?id=352435
# http://www.gentoo.org/foundation/en/minutes/2011/20110220_trustees.meeting_log.txt

S="${WORKDIR}/${MY_PD}"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	base_src_prepare
	eautoreconf
}

src_configure() {
	 econf \
		--with-qt4-include="${EPREFIX}"/usr/include/qt4 \
		--with-qt4-bin="${EPREFIX}"//usr/bin \
		--with-qt4-lib="${EPREFIX}"//usr/$(get_libdir)/qt4 \
		--with-occ-include=${CASROOT}/inc \
		--with-occ-lib=${CASROOT}/lib
}

src_install() {
	emake  DESTDIR="${D}" install || die "install failed"

	find "${D}" -name "*.la" -exec rm {} +

	dodoc README.Linux ChangeLog.txt || die

	dodir /usr/share/apps/freecad || die
	mv "${D}/usr/share/freecad.xpm" "${D}/usr/share/apps/freecad/" || die

	make_desktop_entry FreeCAD FreeCAD /usr/share/apps/freecad/freecad.xpm
}
