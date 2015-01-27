# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

FORTRAN_STANDARD=90
PYTHON_COMPAT=python2_7
inherit eutils cmake-utils fortran-2 versionator python-single-r1

MAJOR_PV=$(get_version_component_range 1-2)

DESCRIPTION="Utilities for processing and plotting neutron scattering data"
HOMEPAGE="http://www.mantidproject.org/"
SRC_URI="mirror://sourceforge/project/${PN}/${MAJOR_PV}/${P}-Source.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc opencl paraview shared-libs tcmalloc test"

RDEPEND="
	${PYTHON_DEPS}
	>=sci-libs/nexus-4.2
	>=dev-libs/poco-1.4.2
	dev-libs/boost[python]
	opencl?		( virtual/opencl )
	tcmalloc?	( dev-util/google-perftools )
	paraview?	( >=sci-visualization/paraview-4 )
	virtual/opengl
	dev-qt/qthelp
	x11-libs/qscintilla
	x11-libs/qwt:5
	x11-libs/qwtplot3d
	dev-python/PyQt4
	sci-libs/gsl
	dev-python/ipython[qt4]
	dev-python/numpy
	sci-libs/scipy
	dev-cpp/muParser
	dev-libs/jsoncpp
	dev-libs/openssl
	sci-libs/opencascade
"

DEPEND="${RDEPEND}
	dev-python/sphinx
	doc?	( app-doc/doxygen
		  dev-python/sphinx
		  dev-python/sphinx-bootstrap-theme )
	test?	( dev-util/cppcheck )
"

S="${WORKDIR}/${P}-Source"

src_prepare() {
	epatch	"${FILESDIR}/${P}-HAVE_IOSTREAM.patch" \
		"${FILESDIR}/${P}-FindOpenCascade.patch" \
		"${FILESDIR}/${P}-minigzip-OF.patch"
}

# pkg_setup() {
# 	python-single-r1_pkg_setup
# 	fortran-2_pkg_setup
# }

src_configure() {
	mycmakeargs=(	$(cmake-utils_use_enable doc QTASSISTANT)
			$(cmake-utils_use_use doc DOT)
			$(cmake-utils_use opencl OPENCL_BUILD)
			$(cmake-utils_use_build shared-libs SHARED_LIBS)
			$(cmake-utils_use_use tcmalloc TCMALLOC)
			$(cmake-utils_use paraview MAKE_VATES)
			$(cmake-utils_use_build test TESTING)
		)
	cmake-utils_src_configure
}