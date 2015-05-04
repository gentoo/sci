# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2
PYTHON_DEPEND="2:2.5"

inherit eutils python

DESCRIPTION="The Open Source Integration Platform for Numerical Simulation - YACS component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://files.opencascade.com/Salome/Salome${PV}/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc opengl"

RDEPEND="
	debug?   ( dev-util/cppunit )
	opengl?  ( virtual/opengl )
	>=sci-misc/salome-kernel-${PV}
	>=sci-misc/salome-gui-${PV}
	>=dev-python/omniorbpy-3.4
	>=sci-libs/hdf5-1.6.4
	>=dev-libs/boost-1.40.0
	>=dev-qt/qtcore-4.5.2
	>=dev-qt/qtgui-4.5.2
	>=dev-qt/qtopengl-4.5.2
	>=dev-python/PyQt4-4.5.4
	>=x11-libs/qscintilla-2.4
	>=net-misc/omniORB-4.1.3
	dev-libs/expat"
DEPEND="${RDEPEND}
	>=app-doc/doxygen-1.5.6
	media-gfx/graphviz
	>=dev-python/docutils-0.4
	dev-lang/swig
	dev-libs/libxml2:2
	>=dev-python/celementtree-1.0.5
	>=dev-python/elementtree-1.2.6
	doc? ( dev-python/sphinx )"

MODULE_NAME="YACS"
S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"

pkg_setup() {
	[[ $(python_get_version) > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-ac_python_devel.patch
	if use amd64; then
		epatch "${FILESDIR}"/"${P}"-lib_location.patch
		epatch "${FILESDIR}"/"${P}"-libdir.patch
	fi

	rm -r -f autom4te.cache
	./clean_configure
	./build_configure
}

src_configure() {
	econf \
		--prefix=${INSTALL_DIR} \
		--datadir=${INSTALL_DIR}/share/salome \
		--docdir=${INSTALL_DIR}/doc/salome \
		--libdir=${INSTALL_DIR}/$(get_libdir)/salome \
		--infodir=${INSTALL_DIR}/share/info \
		--with-qt4=/usr \
		--with-qt4-libraries=/usr/$(get_libdir)/qt4 \
		--with-qsci4-includes=/usr/include/Qsci \
		$(use_enable debug ) \
		$(use_enable !debug production ) \
		$(use_with debug cppunit /usr )
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	use amd64 && dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib

	echo "${MODULE_NAME}_ROOT_DIR=${INSTALL_DIR}" > ./90${P}
	echo "LDPATH=${INSTALL_DIR}/$(get_libdir)/salome" >> ./90${P}
	echo "PATH=${INSTALL_DIR}/bin/salome" >> ./90${P}
	echo "PYTHONPATH=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome" >> ./90${P}
	doenvd 90${P}
	rm adm/Makefile
	insinto "${INSTALL_DIR}"
	doins -r adm

	use doc && dodoc AUTHORS INSTALL NEWS README
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\`"
	elog "now to set up the correct paths."
	elog ""
}
