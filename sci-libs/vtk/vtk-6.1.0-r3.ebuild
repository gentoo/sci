# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
CMAKE_MAKEFILE_GENERATOR=ninja
WEBAPP_OPTIONAL=yes
WEBAPP_MANUAL_SLOT=yes

inherit eutils flag-o-matic java-pkg-opt-2 python-single-r1 qmake-utils versionator toolchain-funcs cmake-utils virtualx webapp

# Short package version
SPV="$(get_version_component_range 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="http://www.vtk.org/"
SRC_URI="
	http://www.${PN}.org/files/release/${SPV}/VTK-${PV}.tar.gz
	doc? ( http://www.${PN}.org/files/release/${SPV}/${PN}DocHtml-${PV}.tar.gz )
	test? (
		http://www.${PN}.org/files/release/${SPV}/VTKData-${PV}.tar.gz
		http://www.${PN}.org/files/release/${SPV}/VTKLargeData-${PV}.tar.gz
		)
	"

LICENSE="BSD LGPL-2"
#KEYWORDS="~arm ~x86 ~amd64-linux ~x86-linux"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="
	all-modules aqua boost cg doc examples imaging ffmpeg gdal java json kaapi mpi
	mysql odbc offscreen postgres python qt4 +qt5 rendering smp tbb test theora tk
	tcl video_cards_nvidia views web xdmf2 R +X"

REQUIRED_USE="
	all-modules? ( python xdmf2 )
	java? ( || ( qt4 qt5 ) )
	python? ( ${PYTHON_REQUIRED_USE} )
	tcl? ( rendering )
	smp? ( ^^ ( kaapi tbb ) )
	test? ( python )
	tk? ( tcl )
	web? ( python )
	^^ ( X aqua offscreen )
	^^ ( qt4 qt5 )
	"

RDEPEND="
	dev-libs/expat
	dev-libs/jsoncpp
	dev-libs/libxml2:2
	>=media-libs/freetype-2.5.4
	media-libs/libpng:0
	media-libs/mesa
	media-libs/libtheora
	media-libs/tiff:0
	sci-libs/exodusii
	sci-libs/hdf5:=
	sci-libs/netcdf-cxx:3
	sys-libs/zlib
	virtual/jpeg:0
	virtual/opengl
	>=x11-libs/gl2ps-1.3.8
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	boost? ( >=dev-libs/boost-1.40.0[mpi?] )
	cg? ( media-gfx/nvidia-cg-toolkit )
	examples? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		sci-libs/vtkdata
	)
	ffmpeg? ( virtual/ffmpeg )
	gdal? ( sci-libs/gdal )
	java? ( >=virtual/jre-1.5:* )
	kaapi? ( <sci-libs/xkaapi-3 )
	mpi? (
		virtual/mpi[cxx,romio]
		python? ( dev-python/mpi4py[${PYTHON_USEDEP}] )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	offscreen? ( media-libs/mesa[osmesa] )
	postgres? ( dev-db/postgresql:= )
	python? (
		${PYTHON_DEPS}
		dev-python/sip[${PYTHON_USEDEP}]
		)
	)
	qt4? (
		dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtsql:4
		dev-qt/qtwebkit:4
		python? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
		)
	qt5? (
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtsql:5
		dev-qt/qtwebkit:5
		python? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
		)
	tbb? ( dev-cpp/tbb )
	tcl? ( dev-lang/tcl:0= )
	tk? ( dev-lang/tk:0= )
	video_cards_nvidia? ( media-video/nvidia-settings )
	web? (
		${WEBAPP_DEPEND}
		python? (
			dev-python/autobahn[${PYTHON_USEDEP}]
			dev-python/twisted-core[${PYTHON_USEDEP}]
			dev-python/zope-interface[${PYTHON_USEDEP}]
			)
		)
	xdmf2? ( sci-libs/xdmf2 )
	R? ( dev-lang/R )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 )"

S="${WORKDIR}"/VTK-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-freetype.patch
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-system.patch
	"${FILESDIR}"/${P}-netcdf.patch
	"${FILESDIR}"/${P}-web.patch
	"${FILESDIR}"/${P}-glext.patch
	"${FILESDIR}"/${P}-memset.patch
	"${FILESDIR}"/${P}-gdal2.patch
	)

RESTRICT=test

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup
	use web && webapp_pkg_setup

	append-cppflags -D__STDC_CONSTANT_MACROS -D_UNICODE
}

src_prepare() {
	sed \
		-e 's:libproj4:libproj:g' \
		-e 's:lib_proj.h:lib_abi.h:g' \
		-i CMake/FindLIBPROJ4.cmake || die

	local x
	# missing: VPIC alglib exodusII freerange ftgl libproj4 mrmpi sqlite utf8 verdict xmdf2 xmdf3
	for x in expat freetype gl2ps hdf5 jpeg jsoncpp libxml2 netcdf oggtheora png tiff zlib; do
		ebegin "Dropping bundled ${x}"
		rm -r ThirdParty/${x}/vtk${x} || die
		eend $?
	done
	rm -r \
		ThirdParty/AutobahnPython/autobahn \
		ThirdParty/Twisted/twisted \
		ThirdParty/ZopeInterface/zope \
		|| die

	use java && export JAVA_HOME="${EPREFIX}/etc/java-config-2/current-system-vm"

	if use mpi; then
		export CC=mpicc
		export CXX=mpicxx
		export FC=mpif90
		export F90=mpif90
		export F77=mpif77
	fi

	cmake-utils_src_prepare
}

src_configure() {
	# general configuration
	local mycmakeargs=(
		-Wno-dev
#		-DCMAKE_SKIP_RPATH=YES
		-DVTK_DIR="${S}"
		-DVTK_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DVTK_DATA_ROOT:PATH="${EPREFIX}/usr/share/${PN}/data"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DVTK_CUSTOM_LIBRARY_SUFFIX=""
		-DBUILD_SHARED_LIBS=ON
		-DVTK_USE_SYSTEM_AUTOBAHN=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DVTK_USE_SYSTEM_FREETYPE=ON
		-DVTK_USE_SYSTEM_FreeType=ON
		-DVTK_USE_SYSTEM_GL2PS=ON
		-DVTK_USE_SYSTEM_HDF5=ON
		-DVTK_USE_SYSTEM_JPEG=ON
		-DVTK_USE_SYSTEM_LIBPROJ4=OFF
#		-DLIBPROJ4_DIR="${EPREFIX}/usr"
		-DVTK_USE_SYSTEM_LIBXML2=ON
		-DVTK_USE_SYSTEM_LibXml2=ON
		-DVTK_USE_SYSTEM_NETCDF=ON
		-DVTK_USE_SYSTEM_OGGTHEORA=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_TWISTED=ON
		-DVTK_USE_SYSTEM_XDMF2=OFF
		-DVTK_USE_SYSTEM_XDMF3=OFF
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DVTK_USE_SYSTEM_ZOPE=ON
		-DVTK_USE_SYSTEM_LIBRARIES=ON
		-DVTK_USE_GL2PS=ON
		-DVTK_USE_LARGE_DATA=ON
		-DVTK_USE_PARALLEL=ON
	)

	mycmakeargs+=(
		-DVTK_EXTRA_COMPILER_WARNINGS=ON
		-DVTK_Group_StandAlone=ON
	)

	mycmakeargs+=(
		-DBUILD_DOCUMENTATION="$(usex doc)"
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_VTK_BUILD_ALL_MODULES_FOR_TESTS="$(usex test)"
		-DVTK_BUILD_ALL_MODULES="$(usex all-modules)"
		-DDOCUMENTATION_HTML_HELP="$(usex doc)"
		-DVTK_Group_Imaging="$(usex imaging)"
		-DVTK_Group_MPI="$(usex mpi)"
		-DVTK_Group_Qt="$(usex qt4)"
		-DVTK_Group_Rendering="$(usex rendering)"
		-DVTK_Group_Tk="$(usex tk)"
		-DVTK_Group_Views="$(usex views)"
		-DVTK_Group_Web="$(usex web)"
		# How to convert this to EAPI 6???
		#$(cmake-utils_use web VTK_WWW_DIR="${ED}/${MY_HTDOCSDIR}")
		-DVTK_WRAP_JAVA="$(usex java)"
		-DVTK_WRAP_PYTHON="$(usex python)"
		-DVTK_WRAP_PYTHON_SIP="$(usex python)"
		-DVTK_WRAP_TCL="$(usex tcl)"
	)

	mycmakeargs+=(
		-DVTK_USE_BOOST="$(usex boost)"
		-DVTK_USE_CG_SHADERS="$(usex cg)"
		-DVTK_USE_ODBC="$(usex odbc)"
		-DVTK_USE_OFFSCREEN="$(usex offscreen)"
		-DVTK_OPENGL_HAS_OSMESA="$(usex offscreen)"
		-DvtkFiltersSMP="$(usex smp)"
		-DVTK_USE_OGGTHEORA_ENCODER="$(usex theora)"
		-DVTK_USE_NVCONTROL="$(usex video_cards_nvidia)"
		-DModule_vtkFiltersStatisticsGnuR="$(usex R)"
		-DVTK_USE_X="$(usex X)"
	)

	# IO
	mycmakeargs+=(
		-DVTK_USE_FFMPEG_ENCODER="$(usex ffmpeg)"
		-DModule_vtkIOGDAL="$(usex gdal)"
		-DModule_vtkIOGeoJSON="$(usex json)"
		-DModule_vtkIOXdmf2="$(usex xdmf2)"
	)
	# Apple stuff, does it really work?
	mycmakeargs+=( -DVTK_USE_COCOA="$(usex aqua)" )

	if use examples || use test; then
		mycmakeargs+=( -DBUILD_TESTING=ON )
	fi

	if use kaapi; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="Kaapi" )
	elif use tbb; then
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="TBB" )
	else
		mycmakeargs+=( -DVTK_SMP_IMPLEMENTATION_TYPE="Sequential" )
	fi

	if use java; then
#		local _ejavahome=${EPREFIX}/etc/java-config-2/current-system-vm
#
#	mycmakeargs+=(
#			-DJAVAC=${EPREFIX}/usr/bin/javac
#			-DJAVAC=$(java-config -c)
#			-DJAVA_AWT_INCLUDE_PATH=${JAVA_HOME}/include
#			-DJAVA_INCLUDE_PATH:PATH=${JAVA_HOME}/include
#			-DJAVA_INCLUDE_PATH2:PATH=${JAVA_HOME}/include/linux
#		)
#
		if [ "${ARCH}" == "amd64" ]; then
			mycmakeargs+=( -DJAVA_AWT_LIBRARY="${JAVA_HOME}/jre/lib/${ARCH}/libjawt.so;${JAVA_HOME}/jre/lib/${ARCH}/xawt/libmawt.so" )
		else
			mycmakeargs+=( -DJAVA_AWT_LIBRARY="${JAVA_HOME}/jre/lib/i386/libjawt.so;${JAVA_HOME}/jre/lib/i386/xawt/libmawt.so" )
		fi
	fi
	if use python; then
		mycmakeargs+=(
			-DVTK_INSTALL_PYTHON_MODULE_DIR="$(python_get_sitedir)"
			-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DPYTHON_LIBRARY="$(python_get_library_path)"
			-DSIP_PYQT_DIR="${EPREFIX}/usr/share/sip"
			-DSIP_INCLUDE_DIR="$(python_get_includedir)"
			-DVTK_PYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DVTK_PYTHON_LIBRARY="$(python_get_library_path)"
			-DVTK_PYTHON_SETUP_ARGS:STRING="--prefix=${PREFIX} --root=${D}"
		)
	fi

	if use qt4; then
		mycmakeargs+=(
			-DVTK_USE_QVTK=ON
			-DVTK_USE_QVTK_OPENGL=ON
			-DVTK_USE_QVTK_QTOPENGL=ON
			-DQT_WRAP_CPP=ON
			-DQT_WRAP_UI=ON
			-DVTK_INSTALL_QT_DIR=/$(get_libdir)/qt4/plugins/designer
			-DDESIRED_QT_VERSION=4
			-DVTK_QT_VERSION=4
			-DQT_MOC_EXECUTABLE="$(qt4_get_bindir)/moc"
			-DQT_UIC_EXECUTABLE="$(qt4_get_bindir)/uic"
			-DQT_INCLUDE_DIR="${EPREFIX}/usr/include/qt4"
			-DQT_QMAKE_EXECUTABLE="$(qt4_get_bindir)/qmake"
		)
	fi

	if use qt5; then
		mycmakeargs+=(
			-DVTK_USE_QVTK=ON
			-DVTK_USE_QVTK_OPENGL=ON
			-DVTK_USE_QVTK_QTOPENGL=ON
			-DQT_WRAP_CPP=ON
			-DQT_WRAP_UI=ON
			-DVTK_INSTALL_QT_DIR=/$(get_libdir)/qt5/plugins/designer
			-DDESIRED_QT_VERSION=5
			-DVTK_QT_VERSION=5
			-DQT_MOC_EXECUTABLE="$(qt5_get_bindir)/moc"
			-DQT_UIC_EXECUTABLE="$(qt5_get_bindir)/uic"
			-DQT_INCLUDE_DIR="${EPREFIX}/usr/include/qt5"
			-DQT_QMAKE_EXECUTABLE="$(qt5_get_bindir)/qmake"
			-DVTK_Group_Qt:BOOL=ON
		)
	fi

	if use R; then
		mycmakeargs+=(
#			-DR_LIBRARY_BLAS=$($(tc-getPKG_CONFIG) --libs blas)
#			-DR_LIBRARY_LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
			-DR_LIBRARY_BLAS=/usr/$(get_libdir)/R/lib/libR.so
			-DR_LIBRARY_LAPACK=/usr/$(get_libdir)/R/lib/libR.so
		)
	fi

	cmake-utils_src_configure
}

src_test() {
	local tcllib
	ln -sf "${BUILD_DIR}"/lib  "${BUILD_DIR}"/lib/Release || die
	for tcllib in "${BUILD_DIR}"/lib/lib*TCL*so; do
		ln -sf $(basename "${tcllib}").1 "${tcllib/.so/-${SPV}.so}" || die
	done
	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib:"${JAVA_HOME}"/jre/lib/${ARCH}/:"${JAVA_HOME}"/jre/lib/${ARCH}/xawt/
	local VIRTUALX_COMMAND="cmake-utils_src_test"
#	local VIRTUALX_COMMAND="cmake-utils_src_test -R Java"
#	local VIRTUALX_COMMAND="cmake-utils_src_test -I 364,365"
	virtualmake
}

src_install() {
	use web && webapp_src_preinst
	# install docs
	HTML_DOCS=( "${S}"/README.html )

	cmake-utils_src_install

	use java && java-pkg_regjar "${ED}"/usr/$(get_libdir)/${PN}.jar

	if use tcl; then
		# install Tcl docs
		docinto vtk_tcl
		dodoc "${S}"/Wrapping/Tcl/README
	fi

	# install examples
	if use examples; then
		insinto /usr/share/${PN}
		mv -v Examples examples || die
		doins -r examples
	fi

	#install big docs
	if use doc; then
		cd "${WORKDIR}"/html || die
		rm -f *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		docinto html
		dodoc -r ./*
	fi

	# environment
	cat >> "${T}"/40${PN} <<- EOF
	VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
	VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}-${SPV}
	VTKHOME=${EPREFIX}/usr
	EOF
	doenvd "${T}"/40${PN}

	use web && webapp_src_install
}

# webapp.eclass exports these but we want it optional #534036
pkg_postinst() {
	use web && webapp_pkg_postinst
}

pkg_prerm() {
	use web && webapp_pkg_prerm
}
