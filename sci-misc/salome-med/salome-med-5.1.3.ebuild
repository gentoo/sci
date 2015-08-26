# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
PYTHON_DEPEND="2:2.5"

inherit eutils flag-o-matic python

DESCRIPTION="The Open Source Integration Platform for Numerical Simulation - MED Component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://files.opencascade.com/Salome/Salome${PV}/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc metis mpi opengl scotch"

RDEPEND="
	>=sci-misc/salome-kernel-${PV}
	>=sci-misc/salome-gui-${PV}
	>=dev-qt/qtcore-4.5.2
	>=dev-qt/qtgui-4.5.2
	>=dev-qt/qtopengl-4.5.2
	>=dev-libs/boost-1.40.0
	>=sci-libs/opencascade-6.3
	>=sci-libs/med-2.3.5
	>=sci-libs/vtk-5.0[python]
	debug?  ( dev-util/cppunit )
	metis?	 ( >=sci-libs/metis-4.0 )
	mpi? ( || (
			sys-cluster/openmpi[cxx]
			sys-cluster/mpich2[cxx]
		) )
	opengl? ( virtual/opengl )
	scotch? ( >=sci-libs/scotch-4.0 )"

DEPEND="${RDEPEND}
	dev-lang/swig
	dev-libs/libxml2:2"

MODULE_NAME="MED"
S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
MED_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"

pkg_setup() {
	[[ $(python_get_version) > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."
	python_set_active_version 2
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-qt4-path.patch
	epatch "${FILESDIR}"/${P}-gcc.patch
	use mpi && epatch "${FILESDIR}"/${P}-mpi.patch
	use metis && epatch "${FILESDIR}"/${P}-check_metis.patch
	if use scotch; then
		epatch "${FILESDIR}"/${P}-check_scotch.patch
		epatch "${FILESDIR}"/${P}-scotch.patch
	fi
	use amd64 && epatch "${FILESDIR}"/${P}-med_int.patch

	rm -r -f autom4te.cache
	./clean_configure
	./build_configure
}

src_configure() {
	local myconf=""
	local vtk_suffix=""

	has_version ">=sci-libs/vtk-5.0" && vtk_suffix="-5.0"
	has_version ">=sci-libs/vtk-5.2" && vtk_suffix="-5.2"
	has_version ">=sci-libs/vtk-5.4" && vtk_suffix="-5.4"

#   --without-mpi does not disable mpi support, just omit it to disable
	if use mpi; then
		if has_version ">=sys-cluster/openmpi-1.2.9"; then
			myconf="${myconf} --with-mpi --with-openmpi"
		elif has_version ">=sys-cluster/mpich2-1.0.8"; then
			myconf="${myconf} --with-mpi --with-mpich"
		fi
	fi

	use amd64 && append-flags -DHAVE_F77INT64

	econf --prefix=${INSTALL_DIR} \
	      --datadir=${INSTALL_DIR}/share/salome \
	      --docdir=${INSTALL_DIR}/doc/salome \
	      --infodir=${INSTALL_DIR}/share/info \
	      --libdir=${INSTALL_DIR}/$(get_libdir)/salome \
	      --with-python-site=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
	      --with-python-site-exec=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
		  --with-qt=/usr \
		  --with-vtk=${VTKHOME} \
		  --with-vtk-version=${vtk_suffix} \
	      ${myconf} \
	      $(use_enable debug ) \
	      $(use_enable !debug production ) \
	      $(use_with debug cppunit_inc /usr/include/cppunit) \
	      $(use_with opengl opengl /usr) \
	      $(use_with metis metis /usr) \
	      $(use_with scotch scotch /usr) \
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

	use doc && dodoc INSTALL README
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\`"
	elog "now to set up the correct paths."
	elog ""
}
