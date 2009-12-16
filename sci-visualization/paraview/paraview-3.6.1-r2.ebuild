# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/paraview/paraview-3.6.1-r1.ebuild,v 1.4 2009/11/24 04:05:41 markusle Exp $

EAPI="2"

inherit distutils eutils flag-o-matic toolchain-funcs versionator python qt4 cmake-utils

MAIN_PV=$(get_major_version)
MAJOR_PV=$(get_version_component_range 1-2)

DESCRIPTION="ParaView is a powerful scientific data visualization application"
HOMEPAGE="http://www.paraview.org"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${P}-openfoam-gpl-r120.patch.bz2
	mirror://gentoo/${P}-openfoam-r120.patch.bz2"

LICENSE="paraview GPL-2"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="mpi python doc examples qt4 plugins overview streaming mysql postgres odbc cg"
# the database backends are exposed in some of the plugins.
# wether gl2ps and cg are exposed in paraview is a good question.
RDEPEND="sci-libs/hdf5
	mpi? ( || (
				sys-cluster/openmpi
				sys-cluster/mpich2[cxx] ) )
	python? ( >=dev-lang/python-2.0 )
	qt4? ( x11-libs/qt-gui:4
			x11-libs/qt-qt3support:4
			x11-libs/qt-assistant:4
			x11-libs/qt-opengl:4 )
	overview? (
		mysql? ( virtual/mysql )
		postgres? ( virtual/postgresql-base )
		odbc? ( dev-db/unixODBC )
	)
	cg? ( media-gfx/nvidia-cg-toolkit )
	dev-libs/libxml2
	media-libs/libpng
	media-libs/jpeg
	media-libs/tiff
	media-video/ffmpeg
	dev-libs/expat
	sys-libs/zlib
	media-libs/freetype
	>=app-admin/eselect-opengl-1.0.6-r1
	virtual/opengl
	sci-libs/netcdf
	x11-libs/libXmu"

DEPEND="${RDEPEND}
		doc? ( app-doc/doxygen )
		overview? ( >=dev-libs/boost-1.37 )"

PVLIBDIR="$(get_libdir)/${PN}-${MAJOR_PV}"
S="${WORKDIR}"/ParaView${MAIN_PV}

pkg_setup() {
	# overview needs qt4 so if overview is enabled and qt4 isn't we abort
	if( ( use overview ) && ! (use qt4) ); then
		einfo "overview requires qt4 to build"
		einfo "you currently have qt4 disabled please enable it"
		einfo "if you really want overview"
		die
	fi

	if( !( use overview ) && ( ( use mysql ) || ( use postgres ) || ( use odbc ) ) ); then
		einfo "The database backends for mysql, postgresql and odbc"
		einfo "are only useful with overview as far as I can tell."
		einfo "Therefore these backend are currently disabled."
		einfo "If you have a use for them inside paraview let us know."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${P}-qt.patch"
	epatch "${FILESDIR}/${P}-pointsprite-disable.patch"
	epatch "${FILESDIR}/${P}-assistant.patch"
	epatch "${DISTDIR}/${P}-openfoam-r120.patch.bz2"
	epatch "${DISTDIR}/${P}-openfoam-gpl-r120.patch.bz2"
	epatch "${FILESDIR}/${P}-no-doc-finder.patch"
	epatch "${FILESDIR}/${P}-VTK-cg-path.patch"

	has_version '>=sci-libs/hdf5-1.8.0' epatch "${FILESDIR}"/${P}-hdf-1.8.3.patch

	# fix GL issues
	sed -e "s:DEPTH_STENCIL_EXT:DEPTH_COMPONENT24:" \
		-i VTK/Rendering/vtkOpenGLRenderWindow.cxx \
		|| die "Failed to fix GL issues."

	# fix plugin install directory
	sed -e "s:\${PV_INSTALL_BIN_DIR}/plugins:/usr/${PVLIBDIR}/plugins:" \
		-i CMake/ParaViewPlugins.cmake \
		|| die "Failed to fix plugin install directories"
}

src_configure(){
	# we do not depend on an external sci-libs/proj - doing so is incompatible
	# with building shared libraries. But we can use gsl or pthreads.
	# Building vtk with the boost library is only required if you want to build OverView and its plugins.
	local mycmakeargs+=(
		"-DPV_INSTALL_LIB_DIR:PATH=${PVLIBDIR}"
		"-DPARAVIEW_USE_SYSTEM_HDF5:BOOL=ON"
		"-DBUILD_SHARED_LIBS:BOOL=ON"
		"-DBUILD_TESTING:BOOL=OFF"
		"-DCMAKE_SKIP_RPATH:BOOL=YES"
		"-DCMAKE_INSTALL_PREFIX:PATH=/usr"
		"-DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF"
		"-DCMAKE_USE_PTHREADS:BOOL=ON"
		"-DCMAKE_COLOR_MAKEFILE:BOOL=TRUE"
		"-DEXPAT_INCLUDE_DIR:PATH=/usr/include"
		"-DEXPAT_LIBRARY=/usr/$(get_libdir)/libexpat.so"
		"-DOPENGL_gl_LIBRARY=/usr/$(get_libdir)/libGL.so"
		"-DOPENGL_glu_LIBRARY=/usr/$(get_libdir)/libGLU.so"
		"-DVTK_USE_SYSTEM_FREETYPE:BOOL=ON"
		"-DVTK_USE_SYSTEM_JPEG:BOOL=ON"
		"-DVTK_USE_SYSTEM_PNG:BOOL=ON"
		"-DVTK_USE_SYSTEM_TIFF:BOOL=ON"
		"-DVTK_USE_SYSTEM_ZLIB:BOOL=ON"
		"-DVTK_USE_SYSTEM_EXPAT:BOOL=ON"
		"-DVTK_USE_RPATH:BOOL=OFF"
		"-DVTK_USE_SYSTEM_LIBXML2:BOOL=ON"
		"-DVTK_USE_OFFSCREEN=TRUE"
		"-DVTK_USE_GEOVIS:BOOL=ON"
		"-DVTK_USE_GL2PS:BOOL=ON"
		"-DVTK_USE_GLSL_SHADERS:BOOL=ON"
		"-DVTK_USE_GUISUPPORT:BOOL=ON"
		"-DVTK_USE_INFOVIS:BOOL=ON"
		"-DVTK_USE_METAIO:BOOL=ON"
		"-DVTK_USE_VIEWS:BOOL=ON"
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use streaming PARAVIEW_BUILD_StreamingParaView)
		$(cmake-utils_use mpi PARAVIEW_USE_MPI)
		$(cmake-utils_use python PARAVIEW_ENABLE_PYTHON)
		$(cmake-utils_use qt4 PARAVIEW_BUILD_QT_GUI)
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_build examples EXAMPLES)
	)

	# Building OverView requires boost and some plugins
	# VTK_USE_N_WAY_ARRAYS is needed for the Array and TableToSparseArrayPanel plugins,
	# it also probably enables some functionality in the Infovis plugin.
	# Plugins in the first list are both required and enabled by OverView
	if use overview; then
		mycmakeargs+=(
			"-DVTK_USE_BOOST:BOOL=ON"
			"-DVTK_USE_N_WAY_ARRAYS:BOOL=ON"
			"-DPARAVIEW_BUILD_OverView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientGraphView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientGraphViewFrame:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientRecordView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientTableView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientTreeView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_Infovis:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_SQLDatabaseGraphSourcePanel:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_SQLDatabaseTableSourcePanel:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_TableToGraphPanel:BOOL=ON"
			$(cmake-utils_use odbc VTK_USE_ODBC)
			$(cmake-utils_use mysql VTK_USE_MYSQL)
			$(cmake-utils_use mysql XDMF_USE_MYSQL)
			$(cmake-utils_use postgres VTK_USE_POSTGRES)
		)
		# The following plugins need overview to build but are not needed to build OverView.
		use plugins && mycmakeargs+=(
			"-DPARAVIEW_BUILD_PLUGIN_Array:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientGeoView2D:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientGeoView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_SplitTableFieldPanel:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ThresholdTablePanel:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_StatisticsToolbar:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_ClientHierarchyView:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_CommonToolbar:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_TableToSparseArrayPanel:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_GraphLayoutFilterPanel:BOOL=ON"
		)
	fi

	# FIXME: compiling against ffmpeg is currently broken
	mycmakeargs+=("-DVTK_USE_FFMPEG_ENCODER:BOOL=OFF")

	# May be if someone is interested we should test this
	# source include a stub of visit but it tries to find an installed copy of visit.
	# It may just need to be pointed there manually
	mycmakeargs+=("-DPARAVIEW_BUILD_PLUGIN_VisItReaderPlugin:BOOL=OFF")

	# PointSprite: Does it require mpi (seems to build without)? say it really should need cmake>2.7 .
	if use plugins; then
		mycmakeargs+=(
			"-DPARAVIEW_BUILD_PLUGIN_CosmoFilters:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_Moments,:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_PointSprite:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_Prism:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_SLACTools:BOOL=ON"
			"-DPARAVIEW_BUILD_PLUGIN_netCDFReaders:BOOL=ON"
			$(cmake-utils_use examples PointSpritePlugin_BUILD_EXAMPLES)
			$(cmake-utils_use python PARAVIEW_BUILD_PLUGIN_pvblot)
		)
		# note about -DPARAVIEW_BUILD_PLUGIN_Streaming 
		# it is enabled if the streaming application is built - off otherwise.
	fi

	# Extra options to build the QT4 client
	use qt4 && mycmakeargs+=(
			"-DVTK_INSTALL_QT_DIR=/${PVLIBDIR}/plugins/designer"
			"-DVTK_USE_QT:BOOL=ON"
			"-DVTK_USE_QVTK_QTOPENGL:BOOL=ON"
			)

	# we also need to append -DH5Tget_array_dims_vers=1 to our CFLAGS
	append-flags -DH5_USE_16_API

	cmake-utils_src_configure
	# if we want to built overview configure has to be called twice 
	# otherwise some variables are not propagated properly
	use overview && cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# rename the assistant wrapper
	if use qt4; then
		mv "${D}"/usr/bin/assistant "${D}"/usr/bin/paraview-assistant \
			|| die "Failed to rename assistant wrapper"
		chmod 0755 "${D}/usr/${PVLIBDIR}/assistant-real" \
			|| die "Failed to change permissions on assistant wrapper"
		newicon Applications/Client/pvIcon.svg "${PN}".svg
		make_desktop_entry paraview Paraview "${PN}".svg
	fi

	# There is no install target for OverView, so we have a manual install
	if use overview; then
		exeinto /usr/"${PVLIBDIR}"
		newexe "${CMAKE_BUILD_DIR}"/bin/OverView OverView-real
		dolib.so "${CMAKE_BUILD_DIR}"/bin/libOverViewCore.so
		mkdir "${D}/usr/${PVLIBDIR}"/OverView-startup
		cd "${CMAKE_BUILD_DIR}"/bin/OverView-startup
		insinto "/usr/${PVLIBDIR}"/OverView-startup
		insopts -m0755
		doins lib*.so
		dosym /usr/"${PVLIBDIR}"/OverView-real /usr/bin/OverView
		newicon "${S}"/Applications/OverView/Icon.png overview.png
		make_desktop_entry OverView "OverView" overview.png
	fi

	# set up the environment
	echo "LDPATH=/usr/${PVLIBDIR}" >> "${T}"/40${PN}
	doenvd "${T}"/40${PN}

	# move and remove some of the files that should not be
	# in /usr/bin
	dohtml "${D}/usr/bin/about.html" && rm -f "${D}/usr/bin/about.html" \
		|| die "Failed to move about.html into doc dir"

	# this binary does not work and probably should not be installed
	rm -f "${D}/usr/bin/vtkSMExtractDocumentation" \
		|| die "Failed to remove vtkSMExtractDocumentation"

	# rename /usr/bin/lproj to /usr/bin/lproj_paraview to avoid
	# a file collision with vtk which installs the same file
	mv "${D}/usr/bin/lproj" "${D}/usr/bin/lproj_paraview"  \
		|| die "Failed to rename /usr/bin/lproj"
}

pkg_postinst() {
	# with Qt4.5 there seem to be issues reading data files
	# under certain locales. Setting LC_ALL=C should fix these.
	echo
	elog "If you experience data corruption during parsing of"
	elog "data files with paraview please try setting your"
	elog "locale to LC_ALL=C."
	elog "The binary /usr/bin/lproj has been renamed to"
	elog "/usr/bin/lproj_paraview to avoid a file collision"
	elog "with vtk."
	echo
}
