# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils cmake-utils fortran-2

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

RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}-Source

BUILD_DIR=${WORKDIR}/${P}-Build
src_unpack() {
	unpack ${A}
	epatch ${S}/Framework/Geometry/CMakeLists.txt ${FILESDIR}/limits.patch
	epatch ${S}/Build/CMake/FindOpenCascade.cmake ${FILESDIR}/find-opencascade.patch
	epatch ${S}/MantidPlot/src/zlib123/minigzip.c ${FILESDIR}/gzip-of.patch
}

src_configure() {
	cmake-utils_src_configure $(cmake-utils_use opencl OPENCL_BUILD) $(cmake-utils_use_build shared SHARED_LIBS) $(cmake-utils_use_use tcmalloc TCMALLOC) $(cmake-utils_use paraview MAKE_VATES) $(cmake-utils_use_no opencascade OPENCASCADE)
}