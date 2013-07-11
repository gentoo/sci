# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/vtk/vtk-5.10.1.ebuild,v 1.6 2013/03/02 23:24:14 hwoarang Exp $

EAPI=5

PYTHON_COMPAT=( python{2_6,2_7} )

WANT_CMAKE="always"

inherit eutils flag-o-matic java-pkg-opt-2 python-single-r1 qt4-r2 versionator toolchain-funcs cmake-utils

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
IUSE="boost chemistry cg doc examples ffmpeg java mpi mysql odbc patented postgres python qt4 R test theora threads tk video_cards_nvidia X"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	dev-libs/expat
	dev-libs/libxml2:2
	media-libs/freetype
	media-libs/libpng
	media-libs/mesa
	media-libs/tiff
	sci-libs/hdf5
	sys-libs/zlib
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	cg? ( media-gfx/nvidia-cg-toolkit )
	examples? (
		dev-qt/qtcore:4[qt3support]
		dev-qt/qtgui:4[qt3support] )
	ffmpeg? ( virtual/ffmpeg )
	java? ( >=virtual/jre-1.5 )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql-base )
	python? (
		${PYTHON_DEPS}
		dev-python/sip[${PYTHON_USEDEP}] )
	qt4? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		dev-qt/qtopengl:4
		dev-qt/qtsql:4
		dev-qt/qtwebkit:4
		python? ( dev-python/PyQt4[${PYTHON_USEDEP}]	)
		)
	tk? ( dev-lang/tk )
	theora? ( media-libs/libtheora )
	tk? ( dev-lang/tk )
	video_cards_nvidia? ( media-video/nvidia-settings )
	R? ( dev-lang/R )"
DEPEND="${RDEPEND}
		java? ( >=virtual/jdk-1.5 )
		boost? ( >=dev-libs/boost-1.40.0[mpi?] )
		dev-util/cmake"

S="${WORKDIR}"/VTK${PV/_rc/.rc}

PATCHES=(
	"${FILESDIR}"/${P}-cg-path.patch
#	"${FILESDIR}"/${PN}-5.6.0-cg-path.patch
#	"${FILESDIR}"/${PN}-5.2.0-tcl-install.patch
#	"${FILESDIR}"/${PN}-5.8.0-R.patch
#	"${FILESDIR}"/${PN}-5.6.0-odbc.patch
#	"${FILESDIR}"/${PN}-5.6.1-ffmpeg.patch
#	"${FILESDIR}"/${PN}-5.6.1-libav-0.8.patch
#	"${FILESDIR}"/${PN}-5.10.1-tcl8.6.patch
#	"${FILESDIR}"/${PN}-5.10.1-ffmpeg-1.patch
	)

pkg_setup() {
	echo
	einfo "Please note that the VTK build occasionally fails when"
	einfo "using parallel make. Hence, if you experience a build"
	einfo "failure please try re-emerging with MAKEOPTS=\"-j1\" first."
	echo

	java-pkg-opt-2_pkg_setup

	use python && python-single-r1_pkg_setup
	append-cppflags -D__STDC_CONSTANT_MACROS
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	# general configuration
	local mycmakeargs=(
		-Wno-dev
#		-DVTK_INSTALL_PACKAGE_DIR=/$(get_libdir)/${PN}-${SPV}
		-DCMAKE_SKIP_RPATH=YES
		-DVTK_DIR="${S}"
		-DVTK_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DVTK_DATA_ROOT:PATH="${EPREFIX}/usr/share/${PN}/data"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_SHARED_LIBS=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DVTK_USE_SYSTEM_FreeType=ON
		-DVTK_USE_SYSTEM_GL2PS=ON
		-DVTK_USE_SYSTEM_HDF5=ON
		-DVTK_USE_SYSTEM_JPEG=ON
#		-DVTK_USE_SYSTEM_LIBPROJ4=ON
		-DVTK_USE_SYSTEM_LibXml2=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_ZLIB=ON
#		-DVTK_USE_SYSTEM_xdmf2=ON
		-DHDF5_LIBRARY="${EPREFIX}/usr/$(get_libdir)"
		-DHDF5_INCLUDE_DIRS="${EPREFIX}/usr/include"
		-DBUILD_TESTING=OFF
		-DBUILD_EXAMPLES=OFF
		-DVTK_USE_HYBRID=ON
		-DVTK_USE_GL2PS=ON
		-DVTK_USE_RENDERING=ON
		-DLD_LIBRARY_PATCH="${BUILD_DIR}/lib"
	)

	# use flag triggered options
	mycmakeargs+=(
		$(cmake-utils_use boost VTK_USE_BOOST)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use doc DOCUMENTATION_HTML_HELP)
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use java VTK_USE_JAVA)
		$(cmake-utils_use mpi VTK_USE_MPI)
		$(cmake-utils_use mysql VTK_USE_MYSQL)
		$(cmake-utils_use patented VTK_USE_PATENTED)
		$(cmake-utils_use postgres VTK_USE_POSTGRES)
		$(cmake-utils_use odbc VTK_USE_ODBC)
		$(cmake-utils_use qt4 VTK_USE_QT)
		$(cmake-utils_use theora VTK_USE_OGGTHEORA_ENCODER)
		$(cmake-utils_use ffmpeg VTK_USE_FFMPEG_ENCODER)
		$(cmake-utils_use tk VTK_USE_TK)
		$(cmake-utils_use threads VTK_USE_PARALLEL)
		$(cmake-utils_use video_cards_nvidia VTK_USE_NVCONTROL)
		$(cmake-utils_use X VTK_USE_X)
		$(cmake-utils_use X VTK_USE_GUISUPPORT)
		$(cmake-utils_use R VTK_USE_GNU_R)
		$(cmake-utils_use chemistry VTK_USE_CHEMISTRY)
	)

	use tk &&
		mycmakeargs+=(
			-DVTK_WRAP_TCL=ON
			-DVTK_WRAP_TK=ON
			-DVTK_TCL_INCLUDE_DIR="${EPREFIX}/usr/include"
			-DVTK_TCL_LIBRARY="${EPREFIX}/usr/$(get_libdir)"
			-DVTK_TK_INCLUDE_DIR="${EPREFIX}/usr/include"
			-DVTK_TK_LIBRARY="${EPREFIX}/usr/$(get_libdir)"
			-DVTK_INSTALL_TCL_DIR="$(get_libdir)"
		)

	use theora && mycmakeargs+=( -DVTK_USE_SYSTEM_OGGTHEORA=ON )

	# mpi needs the parallel framework
	if use mpi && use !threads; then
		mycmakeargs+=( -DVTK_USE_PARALLEL=ON )
	fi

	if use java; then
		mycmakeargs+=(
			-DVTK_WRAP_JAVA=ON
			-DJAVA_AWT_INCLUDE_PATH=`java-config -O`/include
			-DJAVA_INCLUDE_PATH:PATH=`java-config -O`/include
			-DJAVA_INCLUDE_PATH2:PATH=`java-config -O`/include/linux
		)

		if [ "${ARCH}" == "amd64" ]; then
			mycmakeargs+=(-DJAVA_AWT_LIBRARY=`java-config -O`/jre/lib/${ARCH}/libjawt.so)
		else
			mycmakeargs+=(-DJAVA_AWT_LIBRARY:PATH=`java-config -O`/jre/lib/i386/libjawt.so)
		fi
	fi

	if use python; then
		mycmakeargs+=(
			-DPYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DPYTHON_LIBRARY="$(python_get_library_path)"
			-DVTK_WRAP_PYTHON=ON
			-DVTK_WRAP_PYTHON_SIP=ON
			-DSIP_PYQT_DIR="${EPREFIX}/usr/share/sip"
			-DSIP_INCLUDE_DIR="$(python_get_includedir)"
			-DVTK_PYTHON_INCLUDE_DIR="$(python_get_includedir)"
			-DVTK_PYTHON_LIBRARY="$(python_get_library_path)"
			-DVTK_PYTHON_SETUP_ARGS:STRING=--root="${D}")
	fi

	if use qt4 ; then
		mycmakeargs+=(
			-DVTK_USE_GUISUPPORT=ON
			-DVTK_USE_QVTK=ON
			-DVTK_USE_QVTK_OPENGL=ON
			-DVTK_USE_QVTK_QTOPENGL=ON
			-DQT_WRAP_CPP=ON
			-DQT_WRAP_UI=ON
			-DVTK_INSTALL_QT_DIR=/$(get_libdir)/qt4/plugins/${PN}
			-DDESIRED_QT_VERSION=4
			-DQT_MOC_EXECUTABLE="${EPREFIX}/usr/bin/moc"
			-DQT_UIC_EXECUTABLE="${EPREFIX}/usr/bin/uic"
			-DQT_INCLUDE_DIR="${EPREFIX}/usr/include/qt4"
			-DQT_QMAKE_EXECUTABLE="${EPREFIX}/usr/bin/qmake")
	fi

	cmake-utils_src_configure

	cat >> "${BUILD_DIR}"/Utilities/MaterialLibrary/ProcessShader.sh <<- EOF
	#!${EPREFIX}/bin/bash

	export LD_LIBRARY_PATH="${BUILD_DIR}"/lib
	"${BUILD_DIR}"/bin/vtkProcessShader-${SPV} \$@
	EOF
	chmod 750 "${BUILD_DIR}"/Utilities/MaterialLibrary/ProcessShader.sh || die
}

src_install() {
	cmake-utils_src_install

	# install docs
	dohtml "${S}"/README.html || die "Failed to install docs"

	# install Tcl docs
	docinto vtk_tcl
	dodoc "${S}"/Wrapping/Tcl/README || \
		die "Failed to install Tcl docs"

	# install examples
	if use examples; then
		insinto /usr/share/${PN}
		mv -v Examples examples
		doins -r examples || die
		mv -v "${WORKDIR}"/{VTKData${PV},data} || die
		doins -r "${WORKDIR}"/data || die
	fi

	#install big docs
	if use doc; then
		cd "${WORKDIR}"/html
		rm -f *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		insinto "/usr/share/doc/${PF}/api-docs"
		doins -r ./* || die "Failed to install docs"
	fi

	# environment
	cat >> "${T}"/40${PN} <<- EOF
	VTK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data
	VTK_DIR=${EPREFIX}/usr/$(get_libdir)/${PN}-${SPV}
	VTKHOME=${EPREFIX}/usr
	EOF
	doenvd "${T}"/40${PN}
}

pkg_postinst() {
	if use patented; then
		ewarn "Using patented code in VTK may require a license."
		ewarn "For more information, please read:"
		ewarn "http://public.kitware.com/cgi-bin/vtkfaq?req=show&file=faq07.005.htp"
	fi
}
