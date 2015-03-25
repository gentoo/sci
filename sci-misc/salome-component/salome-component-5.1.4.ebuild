# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="2:2.5"

inherit eutils flag-o-matic python

DESCRIPTION="The Open Source Integration Platform for Numerical Simulation - COMPONENT Component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://files.opencascade.com/Salome/Salome${PV}/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc mpi"

RDEPEND="
	>=sci-misc/salome-kernel-${PV}
	>=sci-misc/salome-gui-${PV}
	>=sci-misc/salome-med-${PV}
	>=dev-qt/qtcore-4.4.3
	>=dev-qt/qtgui-4.4.3
	>=dev-qt/qtopengl-4.4.3
	>=x11-libs/qwt-5.2
	>=dev-python/PyQt4-4.4.3
	>=sci-libs/opencascade-6.3
	debug?   ( dev-util/cppunit )
	mpi?
		(
		|| (
			sys-cluster/openmpi[cxx]
			sys-cluster/mpich2[cxx]
			)
		)"
DEPEND="${RDEPEND}
	>=app-doc/doxygen-1.5.6
	media-gfx/graphviz
	>=dev-python/docutils-0.4
	>=dev-python/sip-4.7.7
	dev-lang/swig
	dev-libs/libxml2:2"

MODULE_NAME="COMPONENT"
S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
COMPONENT_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"

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
	local myconf=""

#   --without-mpi does not disable mpi support, just omit it to disable
	if use mpi; then
		append-ldflags -lmpi -lmpi_cxx
		if has_version ">=sys-cluster/openmpi-1.2.9"; then
			myconf="${myconf} --with-mpi --with-openmpi"
		elif has_version ">=sys-cluster/mpich2-1.0.8"; then
			myconf="${myconf} --with-mpi --with-mpich"
			append-flags -DMPICH_IGNORE_CXX_SEEK
		fi
	fi

	econf --prefix=${INSTALL_DIR} \
	      --datadir=${INSTALL_DIR}/share/salome \
	      --docdir=${INSTALL_DIR}/doc/salome \
	      --infodir=${INSTALL_DIR}/share/info \
		  --libdir=${INSTALL_DIR}/$(get_libdir)/salome \
	      --with-python-site=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
	      --with-python-site-exec=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
	      ${myconf} \
	      $(use_enable debug ) \
	      $(use_enable !debug production ) \
	|| die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install \
	|| die "emake install failed"

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
