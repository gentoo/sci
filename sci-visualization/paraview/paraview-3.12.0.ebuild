# Copyright 1999-2012 Gentoo Foundation
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
		x11-libs/qt-gui:4
		x11-libs/qt-qt3support:4
		x11-libs/qt-opengl:4
		|| ( >=x11-libs/qt-assistant-4.7.0:4[compat] <x11-libs/qt-assistant-4.7.0:4 )
		x11-libs/qt-sql:4
		webkit? ( x11-libs/qt-webkit:4 ) )
	adaptive? (
		x11-libs/qt-gui:4
		x11-libs/qt-qt3support:4
		x11-libs/qt-opengl:4
		x11-libs/qt-assistant:4
		webkit? ( x11-libs/qt-webkit:4 ) )
	mysql? ( virtual/mysql )
	coprocessing? ( plugins? ( x11-libs/qt-gui:4 ) )
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
		dev-libs/protobuf
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
	# mpi + hdf5 fix
	#epatch "${FILESDIR}"/${PN}-3.8.0-h5part.patch
	# gcc fix for vtk
	epatch "${FILESDIR}"/${P}-gcc46.patch

	epatch "${FILESDIR}"/${P}-protobuf.patch

	# lib64 fixes
	sed -i "s:/usr/lib:${EPREFIX}/usr/$(get_libdir):g" \
		Utilities/Xdmf2/libsrc/CMakeLists.txt || die
	sed -i "s:\/lib\/python:\/$(get_libdir)\/python:g" \
		Utilities/Xdmf2/CMake/setup_install_paths.py || die

	# Install internal vtk binaries inside /usr/${PVLIBDIR}
	sed -e 's:VTK_INSTALL_BIN_DIR \"/${PV_INSTALL_BIN_DIR}\":VTK_INSTALL_BIN_DIR \"/${PV_INSTALL_LIB_DIR}\":' \
		-i CMake/ParaViewCommon.cmake || die "failed to patch vtk install location"
	sed -e "s:get_target_property(PROTOC_LOCATION protoc_compiler LOCATION):SET(PROTOC_LOCATION \${SYSTEM_PB}):" \
		-e "s:protoc_compiler::" \
		-i ParaViewCore/ServerImplementation/CMakeLists.txt
	sed -i "s:DEPENDS \${in_proto_file} protoc_compiler:DEPENDS \${in_proto_file}:" \
		CMake/ParaViewMacros.cmake

	cd VTK
	epatch "${FILESDIR}"/vtk-5.6.0-cg-path.patch
}

src_configure() {
	mycmakeargs=(
		-DPV_INSTALL_LIB_DIR="${PVLIBDIR}"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DPV_INSTALL_DOC_DIR="${EPREFIX}/usr/share/doc/${PF}"
		-DEXPAT_INCLUDE_DIR="${EPREFIX}"/usr/include
		-DEXPAT_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libexpat.so
		-DOPENGL_gl_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGL.so
		-DOPENGL_glu_LIBRARY="${EPREFIX}"/usr/$(get_libdir)/libGLU.so
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
		-DPARAVIEW_INSTALL_THIRD_PARTY_LIBRARIES=OFF
		-DSYSTEM_PB=$(which protoc))

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
			mycmakeargs+=(
				-DSIP_PYQT_DIR="${EPREFIX}/usr/share/sip"
				-DSIP_INCLUDE_DIR="${EPREFIX}$(python_get_includedir)")
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
	echo "LDPATH=${EPREFIX}/usr/${PVLIBDIR}" >> "${T}"/40${PN}
	echo "PYTHONPATH="${EPREFIX}"/usr/${PVLIBDIR}:/usr/${PVLIBDIR}/site-packages" >> "${T}"/40${PN}
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
		python_mod_cleanup "${EPREFIX}"/usr/$(get_libdir)/"${PN}-${MAJOR_PV}"/site-packages
	fi
}
