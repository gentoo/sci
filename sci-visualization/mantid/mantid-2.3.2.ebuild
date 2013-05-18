# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="Utilities for processing and plotting neutron scattering data"

HOMEPAGE="http://www.mantidproject.org/"

SRC_URI="http://download.mantidproject.org/download.psp?f=kits/mantid/Python27/${PV}/${P}-Source.tar.gz"


LICENSE="GPL-3+"

SLOT="0"

KEYWORDS="~amd64"

IUSE="test doxygen opencl shared tcmalloc paraview opencascade"

DEPEND="sci-libs/nexus
dev-libs/poco
dev-libs/boost[python]
test? ( dev-util/cppcheck )
doxygen? ( app-doc/doxygen )
opencl? ( virtual/opencl )
tcmalloc? ( dev-util/google-perftools )
paraview? ( sci-visualization/paraview )
virtual/opengl
x11-libs/qscintilla
x11-libs/qwt
x11-libs/qwtplot3d
dev-python/pyqwt
sci-libs/gsl
dev-python/numpy
dev-cpp/muParser
opencascade? ( sci-libs/opencascade )
dev-python/sphinx
"
#x11-libs/qt-phonon
#dev-libs/openssl
#"

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-Source

BUILD_DIR=${WORKDIR}/${P}-Build
src_unpack() {
#	if use opencascade
#	then
#		mkdir -pv ${BUILD_DIR} || die
#		cp -v ${FILESDIR}/CMakeCache.txt ${BUILD_DIR}/ || die 
#	fi
	unpack ${A} || die
	patch ${S}/Framework/Geometry/CMakeLists.txt ${FILESDIR}/limits.patch || die
	patch ${S}/Build/CMake/FindOpenCascade.cmake ${FILESDIR}/find-opencascade.patch || die
	patch ${S}/MantidPlot/src/zlib123/minigzip.c ${FILESDIR}/gzip-of.patch || die
}

src_configure() {
	cmake-utils_src_configure $(cmake-utils_use opencl OPENCL_BUILD) $(cmake-utils_use_build shared SHARED_LIBS) $(cmake-utils_use_use tcmalloc TCMALLOC) $(cmake-utils_use paraview MAKE_VATES) $(cmake-utils_use_no opencascade OPENCASCADE)
	 # -C${FILESDIR}/OpenCascade.txt
}

# The following src_compile function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
# For EAPI < 2 src_compile runs also commands currently present in
# src_configure. Thus, if you're using an older EAPI, you need to copy them
# to your src_compile and drop the src_configure function.
#src_compile() {
	# emake (previously known as pmake) is a script that calls the
	# standard GNU make with parallel building options for speedier
	# builds (especially on SMP systems).  Try emake first.  It might
	# not work for some packages, because some makefiles have bugs
	# related to parallelism, in these cases, use emake -j1 to limit
	# make to a single process.  The -j1 is a visual clue to others
	# that the makefiles have bugs that have been worked around.

	#emake || die
#}

# The following src_install function is implemented as default by portage, so
# you only need to call it, if you need different behaviour.
# For EAPI < 4 src_install is just returing true, so you need to always specify
# this function in older EAPIs.
#src_install() {
	# You must *personally verify* that this trick doesn't install
	# anything outside of DESTDIR; do this by reading and
	# understanding the install part of the Makefiles.
	# This is the preferred way to install.
	#emake DESTDIR="${D}" install || die

	# When you hit a failure with emake, do not just use make. It is
	# better to fix the Makefiles to allow proper parallelization.
	# If you fail with that, use "emake -j1", it's still better than make.

	# For Makefiles that don't make proper use of DESTDIR, setting
	# prefix is often an alternative.  However if you do this, then
	# you also need to specify mandir and infodir, since they were
	# passed to ./configure as absolute paths (overriding the prefix
	# setting).
	#emake \
	#	prefix="${D}"/usr \
	#	mandir="${D}"/usr/share/man \
	#	infodir="${D}"/usr/share/info \
	#	libdir="${D}"/usr/$(get_libdir) \
	#	install || die
	# Again, verify the Makefiles!  We don't want anything falling
	# outside of ${D}.

	# The portage shortcut to the above command is simply:
	#
	#einstall || die
#}
