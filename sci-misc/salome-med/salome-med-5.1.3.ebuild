# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:  $

EAPI=2
PYTHON_DEPEND="2:2.4"

inherit distutils eutils flag-o-matic

DESCRIPTION="SALOME : The Open Source Integration Platform for Numerical Simulation. MED Component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://www.stasyan.com/devel/distfiles/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc mpi metis opengl scotch"

RDEPEND="opengl? ( virtual/opengl )
		 mpi?    ( || ( sys-cluster/openmpi[cxx]
		 				sys-cluster/mpich2[cxx] ) )
		 debug?  ( dev-util/cppunit )
		 metis?	 ( >=sci-libs/metis-4.0 )
		 scotch? ( >=sci-libs/scotch-4.0 )
		 >=sci-misc/salome-kernel-${PV}
		 >=sci-misc/salome-gui-${PV}
		 >=x11-libs/qt-core-4.5.2
		 >=x11-libs/qt-gui-4.5.2
		 >=x11-libs/qt-opengl-4.5.2
		 >=dev-libs/boost-1.40.0
		 >=sci-libs/opencascade-6.3
		 >=sci-libs/med-2.3.5
		 >=sci-libs/vtk-5.0[python]"

DEPEND="${RDEPEND}
		dev-lang/swig
		dev-libs/libxml2"

MODULE_NAME="MED"
MY_S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
MED_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"
export OPENPBS="/usr"

pkg_setup() {
	PYVER=$(python_get_version)
	[[ ${PYVER} > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."
}

src_prepare() {
	cd "${MY_S}"

	epatch "${FILESDIR}"/${P}-qt4-path.patch
	epatch "${FILESDIR}"/${P}-gcc.patch
	use mpi && epatch "${FILESDIR}"/${P}-mpi.patch
	use metis && epatch "${FILESDIR}"/${P}-check_metis.patch
	if use scotch; then
		epatch "${FILESDIR}"/${P}-check_scotch.patch
		epatch "${FILESDIR}"/${P}-scotch.patch
	fi

	rm -r -f autom4te.cache
	./clean_configure
	./build_configure
}

src_configure() {
	cd "${MY_S}"
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

	cd "${MY_S}"

	econf --prefix=${INSTALL_DIR} \
	      --datadir=${INSTALL_DIR}/share/salome \
	      --docdir=${INSTALL_DIR}/doc/salome \
	      --infodir=${INSTALL_DIR}/share/info \
	      --libdir=${INSTALL_DIR}/$(get_libdir)/salome \
	      --with-python-site=${INSTALL_DIR}/$(get_libdir)/python${PYVER}/site-packages/salome \
	      --with-python-site-exec=${INSTALL_DIR}/$(get_libdir)/python${PYVER}/site-packages/salome \
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

src_compile() {
	cd "${MY_S}"

	emake || die "emake failed"
}

src_install() {
	cd "${MY_S}"

	emake DESTDIR="${D}" install || die "emake install failed"

	use amd64 && dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib

	echo "${MODULE_NAME}_ROOT_DIR=${INSTALL_DIR}" > ./90${P}
	echo "LDPATH=${INSTALL_DIR}/$(get_libdir)/salome" >> ./90${P}
	echo "PATH=${INSTALL_DIR}/bin/salome" >> ./90${P}
	echo "PYTHONPATH=${INSTALL_DIR}/$(get_libdir)/python${PYVER}/site-packages/salome" >> ./90${P}
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
