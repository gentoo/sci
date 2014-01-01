# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/vtk/vtk-5.10.1.ebuild,v 1.6 2013/03/02 23:24:14 hwoarang Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

inherit eutils flag-o-matic java-pkg-opt-2 python-single-r1 qt4-r2 versionator toolchain-funcs cmake-utils virtualx

# Short package version
SPV="$(get_version_component_range 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="http://www.vtk.org/"
SRC_URI="
	http://www.${PN}.org/files/release/${SPV}/${P/_rc/.rc}.tar.gz
	doc? ( http://www.${PN}.org/files/release/${SPV}/${PN}DocHtml-${PV}.tar.gz )
	examples? ( http://www.${PN}.org/files/release/${SPV}/${PN}data-${PV}.tar.gz )"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="
	aqua boost cg doc examples imaging ffmpeg java mpi mysql odbc
	offscreen postgres python qt4 rendering test theora tk tcl
	video_cards_nvidia views R X"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	tk? ( tcl )
	?? ( X aqua offscreen )"

RDEPEND="
	dev-libs/expat
	dev-libs/libxml2:2
	media-libs/freetype
	media-libs/libpng
	media-libs/mesa
	media-libs/libtheora
	media-libs/tiff
	sci-libs/exodusii
	sci-libs/hdf5
	sci-libs/netcdf-cxx
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/gl2ps
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	cg? ( media-gfx/nvidia-cg-toolkit )
	examples? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
	)
	ffmpeg? ( virtual/ffmpeg )
	java? ( >=virtual/jre-1.5 )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	offscreen? ( media-libs/mesa[osmesa] )
	postgres? ( dev-db/postgresql-base )
	python? (
		${PYTHON_DEPS}
		dev-python/sip[${PYTHON_USEDEP}]
	)
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtsql:4
		dev-qt/qtwebkit:4
		python? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
		)
	tk? ( dev-lang/tk )
	tk? ( dev-lang/tk )
	video_cards_nvidia? ( media-video/nvidia-settings )
	R? ( dev-lang/R )"
DEPEND="${RDEPEND}
	boost? ( >=dev-libs/boost-1.40.0[mpi?] )
	doc? ( app-doc/doxygen )
	java? ( >=virtual/jdk-1.5 )
	dev-util/cmake"

S="${WORKDIR}"/VTK${PV}

PATCHES=(
	"${FILESDIR}"/${P}-cg-path.patch
	"${FILESDIR}"/${P}-install.patch
	"${FILESDIR}"/${P}-system.patch
	"${FILESDIR}"/${P}-netcdf.patch
	"${FILESDIR}"/${P}-vtkpython.patch
	)

pkg_setup() {
	use java && java-pkg-opt-2_pkg_setup
	use python && python-single-r1_pkg_setup

	append-cppflags -D__STDC_CONSTANT_MACROS -D_UNICODE
}

src_prepare() {
	sed \
		-e 's:libproj4:libproj:g' \
		-e 's:lib_proj.h:lib_abi.h:g' \
		-i CMake/FindLIBPROJ4.cmake || die

	local x
	for x in expat freetype gl2ps hdf5 jpeg libxml2 netcdf oggtheora png tiff zlib; do
		rm -r ThirdParty/${x}/vtk${x} || die
	done

	cmake-utils_src_prepare
}

src_configure() {
	# general configuration
	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_SKIP_RPATH=YES
		-DVTK_DIR="${S}"
		-DVTK_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DVTK_DATA_ROOT:PATH="${EPREFIX}/usr/share/${PN}/data"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DVTK_CUSTOM_LIBRARY_SUFFIX=""
		-DBUILD_SHARED_LIBS=ON
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
#		-DVTK_USE_SYSTEM_XDMF2=ON
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DVTK_USE_SYSTEM_LIBRARIES=ON
		-DVTK_USE_GL2PS=ON
		-DVTK_USE_PARALLEL=ON
	)

	mycmakeargs+=(
		-DVTK_EXTRA_COMPILER_WARNINGS=ON
		-DVTK_Group_StandAlone=ON
	)

	mycmakeargs+=(
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use_build examples EXAMPLES)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_build test VTK_BUILD_ALL_MODULES_FOR_TESTS)
		$(cmake-utils_use doc DOCUMENTATION_HTML_HELP)
		$(cmake-utils_use imaging VTK_Group_Imaging)
		$(cmake-utils_use mpi VTK_Group_MPI)
		$(cmake-utils_use qt4 VTK_Group_Qt)
		$(cmake-utils_use rendering VTK_Group_Rendering)
		$(cmake-utils_use tk VTK_Group_Tk)
		$(cmake-utils_use views VTK_Group_Views)
		$(cmake-utils_use java VTK_WRAP_JAVA)
		$(cmake-utils_use python VTK_WRAP_PYTHON)
		$(cmake-utils_use python VTK_WRAP_PYTHON_SIP)
		$(cmake-utils_use tcl VTK_WRAP_TCL)
#		-DVTK_BUILD_ALL_MODULES=ON
	)

	mycmakeargs+=(
		$(cmake-utils_use boost VTK_USE_BOOST)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use odbc VTK_USE_ODBC)
		$(cmake-utils_use offscreen VTK_USE_OFFSCREEN)
		$(cmake-utils_use offscreen VTK_OPENGL_HAS_OSMESA)
		$(cmake-utils_use theora VTK_USE_OGGTHEORA_ENCODER)
		$(cmake-utils_use ffmpeg VTK_USE_FFMPEG_ENCODER)
		$(cmake-utils_use video_cards_nvidia VTK_USE_NVCONTROL)
		$(cmake-utils_use R Module_vtkFiltersStatisticsGnuR)
		$(cmake-utils_use X VTK_USE_X)
	)

	# Apple stuff, does it really work?
	mycmakeargs+=(
		$(cmake-utils_use aqua VTK_USE_COCOA)
	)

	use java && export JAVA_HOME=$(java-config -O)

	if use python; then
		mycmakeargs+=(
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
			-DQT_MOC_EXECUTABLE="${EPREFIX}/usr/bin/moc"
			-DQT_UIC_EXECUTABLE="${EPREFIX}/usr/bin/uic"
			-DQT_INCLUDE_DIR="${EPREFIX}/usr/include/qt4"
			-DQT_QMAKE_EXECUTABLE="${EPREFIX}/usr/bin/qmake"
		)
	fi

	if use R; then
		mycmakeargs+=(
#			-DR_LIBRARY_BLAS=$($(tc-getPKG_CONFIG) --libs blas)
#			-DR_LIBRARY_LAPACK=$($(tc-getPKG_CONFIG) --libs lapack)
			-DR_LIBRARY_BLAS=/usr/lib64/R/lib/libR.so
			-DR_LIBRARY_LAPACK=/usr/lib64/R/lib/libR.so
		)
	fi

	cmake-utils_src_configure

	cat >> "${BUILD_DIR}"/Utilities/MaterialLibrary/ProcessShader.sh <<- EOF
	#!${EPREFIX}/bin/bash

	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib
	"${BUILD_DIR}"/bin/vtkProcessShader \$@
	EOF
	chmod 750 "${BUILD_DIR}"/Utilities/MaterialLibrary/ProcessShader.sh || die
}

src_test() {
	ln -sf "${BUILD_DIR}"/lib  "${BUILD_DIR}"/lib/Release || die
	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib
	local VIRTUALX_COMMAND="cmake-utils_src_test"
	virtualmake
}

src_install() {
	# install docs
	HTML_DOCS=( "${S}"/README.html )

	cmake-utils_src_install

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
		mv -v "${WORKDIR}"/{VTKDATA${PV},data} || die
		doins -r "${WORKDIR}"/data
	fi

	#install big docs
	if use doc; then
		cd "${WORKDIR}"/html
		rm -f *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		insinto "/usr/share/doc/${PF}/api-docs"
		doins -r ./*
	fi

	# environment
	cat >> "${T}"/40${PN} <<- EOF
	VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
	VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}-${SPV}
	VTKHOME=${EPREFIX}/usr
	EOF
	doenvd "${T}"/40${PN}
}
