# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

PYTHON_DEPEND="python? 2:2.6"

inherit cmake-utils eutils flag-o-matic multilib python qt4-r2 toolchain-funcs versionator

MAIN_PV=$(get_major_version)
MAJOR_PV=$(get_version_component_range 1-2)
MY_P="ParaView-${PV}"

DESCRIPTION="ParaView is a powerful scientific data visualization application"
HOMEPAGE="http://www.paraview.org"
SRC_URI="http://www.paraview.org/files/v${MAJOR_PV}/${MY_P}.tar.gz"
RESTRICT="mirror"

LICENSE="paraview GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="adaptive cg -coprocessing doc examples +gui mpi mysql nvcontrol plugins +python streaming webkit"

RDEPEND="
	sci-libs/hdf5[mpi=]
	mpi? ( virtual/mpi[cxx,romio] )
	gui? (
		dev-qt/qtgui:4
		dev-qt/qt3support:4
		dev-qt/qtopengl:4
		|| ( >=dev-qt/qthelp-4.7.0:4[compat] <dev-qt/qthelp-4.7.0:4 )
		dev-qt/qtsql:4
		webkit? ( dev-qt/qtwebkit:4 ) )
	adaptive? (
		dev-qt/qtgui:4
		dev-qt/qt3support:4
		dev-qt/qtopengl:4
		dev-qt/qthelp:4
		webkit? ( dev-qt/qtwebkit:4 ) )
	mysql? ( virtual/mysql )
	coprocessing? ( plugins? ( dev-qt/qtgui:4 ) )
	python? (
		dev-python/sip
		dev-python/PyQt4
	)
	dev-libs/libxml2:2
	media-libs/libpng
	virtual/jpeg
	media-libs/tiff
	dev-libs/expat
	sys-libs/zlib
	media-libs/freetype
	>=app-admin/eselect-opengl-1.0.6-r1
	virtual/opengl
	sci-libs/netcdf
	x11-libs/libXmu"
DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )
		>=dev-util/cmake-2.6.4"

PVLIBDIR=$(get_libdir)/${PN}-${MAJOR_PV}
S=${WORKDIR}/${MY_P}

pkg_setup() {
	use python && python_set_active_version 2
}

src_prepare() {
	# gcc header fix
	epatch "${FILESDIR}"/${PN}-3.8.0-xdmf-cstring.patch
	# disable automatic byte compiling that act directly on the live system
	epatch "${FILESDIR}"/${PN}-3.8.0-xdmf-bc.patch
	# Install properly pointspritedemo without duplicate DESTDIR
	epatch "${FILESDIR}"/${PN}-3.8.0-pointsprite-example-install.patch
	# mpi + hdf5 fix
	#epatch "${FILESDIR}"/${PN}-3.8.0-h5part.patch
	# gcc fix for vtk
	epatch "${FILESDIR}"/${P}-gcc46.patch

	# lib64 fixes
	sed -i "s:/usr/lib:/usr/$(get_libdir):g" \
		Utilities/Xdmf2/libsrc/CMakeLists.txt || die
	sed -i "s:\/lib\/python:\/$(get_libdir)\/python:g" \
		Utilities/Xdmf2/CMake/setup_install_paths.py || die

	# Install internal vtk binaries inside /usr/${PVLIBDIR}
	sed -e 's:VTK_INSTALL_BIN_DIR \"/${PV_INSTALL_BIN_DIR}\":VTK_INSTALL_BIN_DIR \"/${PV_INSTALL_LIB_DIR}\":' \
		-i CMake/ParaViewCommon.cmake || die "failed to patch vtk install location"

	cd VTK
	epatch "${FILESDIR}"/vtk-5.6.0-cg-path.patch

	# help vtk to find PyQT4 sip if required
	sed -e 's:/usr/share/sip/PyQt4:/usr/share/sip:' \
		-i GUISupport/Qt/CMakeLists.txt
}

src_configure() {
	mycmakeargs=(
		-DPV_INSTALL_LIB_DIR="${PVLIBDIR}"
		-DCMAKE_INSTALL_PREFIX=/usr
		-DPV_INSTALL_DOC_DIR="/usr/share/doc/${PF}"
		-DEXPAT_INCLUDE_DIR=/usr/include
		-DEXPAT_LIBRARY=/usr/$(get_libdir)/libexpat.so
		-DOPENGL_gl_LIBRARY=/usr/$(get_libdir)/libGL.so
		-DOPENGL_glu_LIBRARY=/usr/$(get_libdir)/libGLU.so
		-DCMAKE_SKIP_RPATH=YES
		-DVTK_USE_RPATH=OFF
		-DBUILD_SHARED_LIBS=ON
		-DVTK_USE_SYSTEM_FREETYPE=ON
		-DVTK_USE_SYSTEM_JPEG=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DPARAVIEW_USE_SYSTEM_HDF5=ON
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DCMAKE_COLOR_MAKEFILE=TRUE
		-DVTK_USE_SYSTEM_LIBXML2=ON
		-DVTK_USE_OFFSCREEN=TRUE
		-DCMAKE_USE_PTHREADS=ON
		-DBUILD_TESTING=OFF
		-DVTK_USE_FFMPEG_ENCODER=OFF
		-DPARAVIEW_INSTALL_THIRD_PARTY_LIBRARIES=OFF)

	# use flag triggered options
	mycmakeargs+=(
		$(cmake-utils_use gui PARAVIEW_BUILD_QT_GUI)
		$(cmake-utils_use gui VTK_USE_QVTK)
		$(cmake-utils_use gui VTK_USE_QVTK_QTOPENGL)
		$(cmake-utils_use mpi PARAVIEW_USE_MPI)
		$(cmake-utils_use mpi PARAVIEW_USE_MPI_SSEND)
		$(cmake-utils_use python PARAVIEW_ENABLE_PYTHON)
		$(cmake-utils_use python VTK_WRAP_PYTHON_SIP)
		$(cmake-utils_use python XDMF_WRAP_PYTHON)
		$(cmake-utils_use doc BUILD_DOCUMENTATION)
		$(cmake-utils_use examples BUILD_EXAMPLES)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use nvcontrol VTK_USE_NVCONTROL)
		$(cmake-utils_use adaptive PARAVIEW_BUILD_AdaptiveParaView)
		$(cmake-utils_use streaming PARAVIEW_BUILD_StreamingParaView)
		$(cmake-utils_use mysql XDMF_USE_MYSQL)
		$(cmake-utils_use coprocessing PARAVIEW_ENABLE_COPROCESSING))

	if ( use gui || use adaptive ); then
		mycmakeargs+=(-DVTK_INSTALL_QT_DIR=/${PVLIBDIR}/plugins/designer
			$(cmake-utils_use webkit VTK_QT_USE_WEBKIT))
		if use python ; then
			# paraview cannot guess sip directory right probably because a path is not propagated properly
			mycmakeargs+=(-DSIP_INCLUDE_DIR=$(python_get_includedir))
		fi
	fi

	# the rest of the plugins
	mycmakeargs+=(
		$(cmake-utils_use plugins PARAVIEW_INSTALL_DEVELOPMENT)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_ClientChartView)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_CosmoFilters)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_H5PartReader)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_Moments)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_PointSprite)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_Prism)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SLACTools)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_AnalyzeNIfTIReaderWriter)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SurfaceLIC)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_EyeDomeLighting)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_ForceTime)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_SierraPlotTools)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_StreamingView)
		$(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_VisTrailPlugin))

	if use python; then
		mycmakeargs+=($(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_pvblot))
	fi

	if use coprocessing; then
		mycmakeargs+=($(cmake-utils_use plugins PARAVIEW_BUILD_PLUGIN_CoProcessingScriptGenerator))
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# set up the environment
	echo "LDPATH=/usr/${PVLIBDIR}" >> "${T}"/40${PN}
	echo "PYTHONPATH=/usr/${PVLIBDIR}:/usr/${PVLIBDIR}/site-packages" >> "${T}"/40${PN}
	doenvd "${T}"/40${PN}

	# last but not least lets make a desktop entry
	newicon "${S}"/Applications/ParaView/pvIcon.png paraview.png \
		|| die "Failed to create paraview icon."
	make_desktop_entry paraview "Paraview" paraview \
		|| die "Failed to install Paraview desktop entry"

}

pkg_postinst() {
	# with Qt4.5 there seem to be issues reading data files
	# under certain locales. Setting LC_ALL=C should fix these.
	echo
	elog "If you experience data corruption during parsing of"
	elog "data files with paraview please try setting your"
	elog "locale to LC_ALL=C."
	echo
}

pkg_postrm() {
	if use python ; then
		python_mod_cleanup /usr/$(get_libdir)/"${PN}-${MAJOR_PV}"/site-packages
	fi
}
