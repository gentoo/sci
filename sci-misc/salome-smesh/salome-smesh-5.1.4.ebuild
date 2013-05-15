# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2
PYTHON_DEPEND="2:2.5"

inherit eutils flag-o-matic python

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation. SMESH Component"
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
		 >=sci-misc/salome-med-${PV}
		 >=sci-misc/salome-geom-${PV}
		 >=dev-python/omniorbpy-3.4
		 >=net-misc/omniORB-4.1.4
		 >=dev-qt/qtcore-4.5.2
		 >=dev-qt/qtgui-4.5.2
		 >=dev-qt/qtopengl-4.5.2
		 >=x11-libs/qwt-5.2
		 >=dev-libs/boost-1.40.0
		 >=sci-libs/opencascade-6.3
		 >=sci-libs/hdf5-1.6.4
		 >=sci-libs/med-2.3.5
		 >=sci-libs/vtk-5.0[python]"

DEPEND="${RDEPEND}
		dev-lang/swig
		>=app-doc/doxygen-1.5.6
		media-gfx/graphviz
		>=dev-python/docutils-0.4"

MODULE_NAME="SMESH"
S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
SMESH_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"

pkg_setup() {
	[[ $(python_get_version) > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."
	python_set_active_version 2
	append-ldflags $(no-as-needed)
}

src_prepare() {
	rm -r -f autom4te.cache
	./build_configure
}

src_configure() {
	local vtk_suffix=""

	has_version ">=sci-libs/vtk-5.0" && vtk_suffix="-5.0"
	has_version ">=sci-libs/vtk-5.2" && vtk_suffix="-5.2"
	has_version ">=sci-libs/vtk-5.4" && vtk_suffix="-5.4"
	has_version ">=sci-libs/vtk-5.6" && vtk_suffix="-5.6"

	use amd64 && append-flags -DHAVE_F77INT64

	# Configuration
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
		  --with-qwt_inc='/usr/include/qwt5' \
	      $(use_enable debug ) \
	      $(use_enable !debug production ) \
	      $(use_with opengl opengl /usr) \
	|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	use amd64 && dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib

	echo "${MODULE_NAME}_ROOT_DIR=${INSTALL_DIR}" > ./90${P}
	echo "LDPATH=${INSTALL_DIR}/$(get_libdir)/salome" >> ./90${P}
	echo "PATH=${INSTALL_DIR}/bin/salome" >> ./90${P}
	echo "PYTHONPATH=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome" >> ./90${P}
	doenvd 90${P}
	rm adm_local/Makefile
	insinto "${INSTALL_DIR}"
	doins -r adm_local

	use doc && dodoc INSTALL
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\`"
	elog "now to set up the correct paths."
	elog ""
}
