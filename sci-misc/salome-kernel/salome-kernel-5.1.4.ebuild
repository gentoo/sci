# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
PYTHON_DEPEND="2:2.5"

inherit eutils python

DESCRIPTION="The Open Source Integration Platform for Numerical Simulation - KERNEL Component"
HOMEPAGE="http://www.salome-platform.org"
SRC_URI="http://files.opencascade.com/Salome/Salome${PV}/src${PV}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug doc mpi numpy"

RDEPEND="
	>=dev-python/omniorbpy-3.4
	>=net-misc/omniORB-4.1.4
	>=dev-libs/boost-1.40.0
	 sci-libs/hdf5
	debug?   ( dev-util/cppunit )
	mpi?
		( || (
			sys-cluster/openmpi[cxx]
			sys-cluster/mpich2[cxx]
			) )
	numpy?   ( dev-python/numpy )"
DEPEND="${RDEPEND}
	>=app-doc/doxygen-1.5.6
	media-gfx/graphviz
	dev-python/docutils
	dev-lang/swig
	dev-libs/libxml2:2
	>=dev-python/docutils-0.4"

MODULE_NAME="KERNEL"
S="${WORKDIR}/src${PV}/${MODULE_NAME}_SRC_${PV}"
INSTALL_DIR="/opt/salome-${PV}/${MODULE_NAME}"
KERNEL_ROOT_DIR="/opt/salome-${PV}/${MODULE_NAME}"

pkg_setup() {
	[[ $(python_get_version) > 2.4 ]] && \
		ewarn "Python 2.4 is highly recommended for Salome..."

	#Warn about mpi use flag for hdf5
	has_version "sci-libs/hdf5[mpi]" &&
		ewarn "mpi use flag enabled for sci-libs/hdf5, this may cause the build to fail for salome-kernel"
	python_set_active_version 2
}

src_prepare() {
	use amd64 && epatch "${FILESDIR}"/${P}-lib_location.patch
	[[ $(python_get_version) == 2.6 ]] && \
		epatch "${FILESDIR}"/${P}-python-2.6.patch

	has_version "sys-cluster/openmpi" && \
		epatch "${FILESDIR}"/${P}-openmpi.patch

	./clean_configure
	./build_configure
}

src_configure() {
	local myconf=""

#   --without-mpi does not disable mpi support, just omit it to disable
	if use mpi; then
		if has_version ">=sys-cluster/openmpi-1.2.9"; then
			myconf="${myconf} --with-mpi --with-openmpi"
		elif has_version ">=sys-cluster/mpich2-1.0.8"; then
			myconf="${myconf} --with-mpi --with-mpich"
		fi
	fi

	econf --prefix=${INSTALL_DIR} \
	      --docdir=${INSTALL_DIR}/share/doc/salome \
	      --infodir=${INSTALL_DIR}/share/info \
	      --datadir=${INSTALL_DIR}/share/salome \
	      --with-python-site=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
	      --with-python-site-exec=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome \
	      --enable-corba-gen \
	      ${myconf} \
	      $(use_enable mpi parallel_extension ) \
	      $(use_enable debug ) \
	      $(use_enable !debug production ) \
	      $(use_with debug cppunit /usr ) \
	|| die "econf failed"
}

src_install() {
	MAKEOPTS="-j1" emake DESTDIR="${D}" install || die "emake install failed"

	use amd64 && dosym ${INSTALL_DIR}/lib64 ${INSTALL_DIR}/lib

	echo "KERNEL_ROOT_DIR=${INSTALL_DIR}" > ./90${P}
	echo "LDPATH=${INSTALL_DIR}/$(get_libdir)/salome" >> ./90${P}
	echo "PATH=${INSTALL_DIR}/bin/salome"   >> ./90${P}
	echo "PYTHONPATH=${INSTALL_DIR}/$(get_libdir)/python$(python_get_version)/site-packages/salome" >> ./90${P}
	doenvd 90${P}
	use doc && dodoc AUTHORS ChangeLog INSTALL NEWS README README.FIRST.txt

	# Install icon and .desktop for menu entry
	doicon "${FILESDIR}"/${PN}.png
	make_desktop_entry runSalome Salome ${PN} "Science;Engineering"
}

pkg_postinst() {
	elog "Run \`env-update && source /etc/profile\`"
	elog "now to set up the correct paths."
	elog ""

	ewarn "note a small change to /etc/hosts may be required"
	ewarn "salome doesn't seem to recognise localhost within the hosts file"
	ewarn "a line such as"
	ewarn "127.0.0.1	name.domain	name"
	ewarn "may be required within /etc/hosts"
	ewarn ""
}
