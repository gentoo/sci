# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit autotools eutils qt4-r2 subversion python-single-r1 versionator

ELMER_ROOT="elmerfem"
MY_PN=ElmerGUI

DESCRIPTION="a collection of finite element programs, libraries, and visualization tools, New Elmer pre-processor"
HOMEPAGE="http://www.csc.fi/english/pages/elmer"
SRC_URI=""
ESVN_REPO_URI="https://elmerfem.svn.sourceforge.net/svnroot/elmerfem/trunk/${MY_PN}"
ESVN_PROJECT="${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug +bundled_netgen matc opencascade python qwt vtk"

REQUIRED_USE="opencascade? ( vtk )"

DEPEND="
	~sci-libs/elmer-eio-${PV}
	!bundled_netgen? ( sci-mathematics/netgen )
	virtual/glu
	|| (
		~sci-misc/elmer-post-${PV}
		>=sci-libs/vtk-5.0.0[qt4,python?]
		)
	matc? ( ~sci-libs/matc-${PV} )
	vtk? ( >=sci-libs/vtk-5.0.0[qt4,python?] )
	opencascade? ( >=sci-libs/opencascade-6.3:* )
	python? ( dev-python/pythonqt[${PYTHON_USEDEP}] )
	qwt? ( x11-libs/qwt:5 )
	>=dev-qt/qtcore-4.3:4
	>=dev-qt/qtopengl-4.3:4
	>=dev-qt/qtscript-4.3:4"
RDEPEND="${DEPEND}"

src_prepare() {
	# Do not build bundled matc and PythonQt
	sed \
		-e 's/matc//' \
		-e 's/PythonQt//' \
		-i ${MY_PN}.pro || die

	# Ideally we would avoid buildling thirdparty code
	# and use a separate package but this currently fails
	# to build. ElmerGui provides its own patched version of
	# NetGen. Currently considering backporting them to
	# sci-mathematics/netgen
	if use !bundled_netgen; then
		   sed -i 's/netgen//' ${MY_PN}.pro || die
		   sed \
				-e "s:INCLUDEPATH += ../netgen/libsrc/interface:INCLUDEPATH += ${EPREFIX}/usr/include:g" \
				-e "s:LIBPATH += ../netgen/ngcore:LIBPATH += ${EPREFIX}/usr/$(get_libdir):g" \
				-e "s:LIBS += -lng:LIBS += -lnglib:g" \
				-i Application/Application.pro || die

			eerror "${PN} currently fails to build against sci-mathematics/netgen."
	fi

	# Fix install path
	sed \
		-e 's|unix: ELMER_HOME = /usr/local|unix: ELMER_HOME = /usr|g' \
		-i ${MY_PN}.pri || die

	if use amd64; then
		   sed -i 's/32/64/' ${MY_PN}.pri || die
	fi

	if use !qwt; then
		   # QWT is activated by default, disable
		   sed -i 's/DEFINES += EG_QWT//' ${MY_PN}.pri || die
	else
		   # Detect x11-libs/qwt version and fix paths
		   local QWT_VER=`echo $(best_version "x11-libs/qwt") | sed 's:x11-libs/qwt-::'`
		   local QWT_MAJOR=$(get_major_version ${QWT_VER})
		   local QWT_MAJOR=5

		   if [[ ${QWT_MAJOR} -lt 6 ]]; then
			   local QWT_LIBS=-lqwt
		   else
			   local QWT_LIBS=-lqwt${QWT_MAJOR}
		   fi

		   local QWT_INCLUDEPATH=${EPREFIX}/usr/include/qwt${QWT_MAJOR}
		   local QWT_LIBPATH=${EPREFIX}/usr/$(get_libdir)

		   sed -i \
			   -e "s:QWT_INCLUDEPATH.*:QWT_INCLUDEPATH = ${QWT_INCLUDEPATH}:g" \
			   -e "s:QWT_LIBPATH.*:QWT_LIBPATH = ${QWT_LIBPATH}:g" \
			   -e "s:QWT_LIBS.*:QWT_LIBS = ${QWT_LIBS}:g" \
			   ${MY_PN}.pri || die
	fi

	if use !vtk; then
		   # VTK is activated by default, disable
		   sed -i 's/DEFINES += EG_VTK//' ${MY_PN}.pri || die
	else
		   # Fix paths
		   local VTK_VER=`echo ${VTK_DIR} | cut -d/ -f4`
		   sed -i \
			   -e "s:VTK_INCLUDEPATH.*:VTK_INCLUDEPATH = ${EPREFIX}/usr/include/${VTK_VER}:g" \
			   -e "s:VTK_LIBPATH.*:VTK_LIBPATH = ${VTK_DIR}:g" \
			   ${MY_PN}.pri || die
	fi

	if use !matc; then
		   sed -i 's/DEFINES += EG_MATC//' ${MY_PN}.pri || die
	else
		   sed -i "s:LIBPATH += ../matc/lib:LIBPATH += ${EPREFIX}/usr/$(get_libdir):g" Application/Application.pro || die
	fi

	if use !opencascade; then
		   # Opencascade is activated by default, disable
		   sed -i 's/DEFINES += EG_OCC//' ${MY_PN}.pri || die
	else
		   # Fix paths, depend on portage version of opencascade
		   sed -i \
			   -e "s:OCC_INCLUDEPATH.*:OCC_INCLUDEPATH = ${CASROOT}/inc:g" \
			   -e "s:OCC_LIBPATH.*:OCC_LIBPATH = ${CASROOT}/$(get_libdir):g" \
			   ${MY_PN}.pri || die
	fi

	if use python; then
		   # Fix paths
		   sed -i \
			   -e 's/DEFINES -= EG_PYTHON/DEFINES += EG_PYTHON/g' \
			   -e "s:PY_INCLUDEPATH.*:PY_INCLUDEPATH = $(python_get_includedir):g" \
			   -e "s:PY_LIBPATH.*:PY_LIBPATH = $(python_get_libdir):g" \
			   -e "s:PY_LIBS.*:PY_LIBS = $(python_get_library -l):g" \
			   ${MY_PN}.pri || die

		   # Fix paths and invert Python(Qt) linking order to work with --Wl,--as-needed
		   sed -i \
			   -e "s:INCLUDEPATH += $${PY_INCLUDEPATH} ../PythonQt/src:${EPREFIX}/usr/include/PythonQt:g" \
			   -e "s:LIBPATH += $${PY_LIBPATH} ../PythonQt/lib:${EPREFIX}/usr/$(get_libdir):g" \
			   -e "s:LIBS += $${PY_LIBS} -lPythonQt:LIBS += -lPythonQt $${PY_LIBS}:" \
			   Application/Application.pro || die
	fi
}

src_configure() {
	eqmake4 "${S}" ./${MY_PN}.pro
}
