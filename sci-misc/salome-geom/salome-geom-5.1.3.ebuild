# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.5"

inherit eutils python

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation. GEOM component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://files.opencascade.com/Salome/Salome${PV}/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc mpi opengl"

RDEPEND="opengl?  ( virtual/opengl )
		 mpi?     ( || ( sys-cluster/openmpi[cxx]
		 				 sys-cluster/mpich2[cxx] ) )
	 	 debug?   ( dev-util/cppunit )
		 >=sci-misc/salome-kernel-${PV}
		 >=sci-misc/salome-gui-${PV}
		 >=dev-python/omniorbpy-3.4
		 >=net-misc/omniORB-4.1.4
		 >=dev-qt/qtcore-4.5.2
		 >=dev-qt/qtgui-4.5.2
		 >=dev-qt/qtopengl-4.5.2
		 >=sci-libs/opencascade-6.3
		 >=dev-libs/boost-1.40.0
		 >=sci-libs/vtk-5.0[python]
		 >=sci-libs/hdf5-1.6.4"

DEPEND="${RDEPEND}
		>=app-doc/doxygen-1.5.6
		media-gfx/graphviz
		>=dev-python/docutils-0.4
		dev-lang/swig"

MODULE_NAME="GEOM"
S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
GEOM_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"

pkg_setup() {
	[[ $(python_get_version) > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-qt4-path.patch

	rm -r -f autom4te.cache
	./clean_configure
	./build_configure
}

src_configure() {
	local vtk_suffix=""

	has_version ">=sci-libs/vtk-5.0" && vtk_suffix="-5.0"
	has_version ">=sci-libs/vtk-5.2" && vtk_suffix="-5.2"
	has_version ">=sci-libs/vtk-5.4" && vtk_suffix="-5.4"

	econf --prefix=${INSTALL_DIR} \
	      --datadir=${INSTALL_DIR}/share/salome \
	      --docdir=${INSTALL_DIR}/doc/salome \
	      --infodir=${INSTALL_DIR}/share/info \
	      --libdir=${INSTALL_DIR}/$(get_libdir)/salome \
	      --with-python-site=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
	      --with-python-site-exec=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
		  --with-vtk=${VTKHOME} \
		  --with-vtk-version=${vtk_suffix} \
		  --with-qt='/usr' \
	      $(use_enable debug ) \
	      $(use_enable debug debug ) \
	      $(use_enable !debug production ) \
	      $(use_with opengl opengl /usr) \
	|| die "econf failed"
}

src_compile() {
	MAKEOPTS+=" -j1" emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	use amd64 && dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib

	echo "${MODULE_NAME}_ROOT_DIR=${INSTALL_DIR}" > ./90${P}
	echo "LDPATH=${INSTALL_DIR}/$(get_libdir)/salome" >> ./90${P}
	echo "PATH=${INSTALL_DIR}/bin/salome" >> ./90${P}
	echo "PYTHONPATH=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome" >> ./90${P}
	doenvd 90${P}
	rm adm_local/Makefile adm_local/unix/Makefile adm_local/cmake_files/Makefile
	insinto "${INSTALL_DIR}"
	doins -r adm_local

	use doc && dodoc INSTALL
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\`"
	elog "now to set up the correct paths."
	elog ""
}
