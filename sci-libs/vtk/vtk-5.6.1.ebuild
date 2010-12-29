# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
PYTHON_DEPEND="python? 2"

inherit eutils flag-o-matic java-pkg-opt-2 python qt4-r2 versionator toolchain-funcs cmake-utils

# Short package version
SPV="$(get_version_component_range 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="http://www.vtk.org"
SRC_URI="http://www.${PN}.org/files/release/${SPV}/${P}.tar.gz
		examples? ( http://www.${PN}.org/files/release/${SPV}/${PN}data-${PV}.tar.gz )
		doc? ( http://www.${PN}.org/doc/release/${SPV}/${PN}DocHtml-${PV}.tar.gz )"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="boost cg doc examples ffmpeg java mpi mysql odbc patented postgres python qt4 tcl theora tk threads R"
RDEPEND="
	cg? ( media-gfx/nvidia-cg-toolkit )
	examples? (
			x11-libs/qt-core:4[qt3support]
			x11-libs/qt-gui:4[qt3support] )
	ffmpeg? ( media-video/ffmpeg )
	java? ( >=virtual/jre-1.5 )
	mpi? ( virtual/mpi[cxx,romio] )
	mysql? ( virtual/mysql )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql-base )
	qt4? (
			x11-libs/qt-core:4
			x11-libs/qt-gui:4
			x11-libs/qt-opengl:4
			x11-libs/qt-sql:4
			x11-libs/qt-webkit:4 )
	tcl? ( >=dev-lang/tcl-8.2.3 )
	theora? ( media-libs/libtheora )
	tk? ( >=dev-lang/tk-8.2.3 )
	R? ( dev-lang/R )
	dev-libs/expat
	dev-libs/libxml2
	media-libs/freetype
	virtual/jpeg
	media-libs/libpng
	media-libs/mesa
	media-libs/tiff
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt"

DEPEND="${RDEPEND}
		java? ( >=virtual/jdk-1.5 )
		boost? ( >=dev-libs/boost-1.40.0[mpi?] )
		mpi? ( >=dev-util/cmake-2.8.1-r2 )
		>=dev-util/cmake-2.6"

S="${WORKDIR}"/VTK

pkg_setup() {
	echo
	einfo "Please note that the VTK build occasionally fails when"
	einfo "using parallel make. Hence, if you experience a build"
	einfo "failure please try re-emerging with MAKEOPTS=\"-j1\" first."
	echo

	java-pkg-opt-2_pkg_setup

	use python && python_set_active_version 2
	use qt4 && qt4_pkg_setup
	append-cppflags -D__STDC_CONSTANT_MACROS
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.6.0-cg-path.patch
	epatch "${FILESDIR}"/${PN}-5.2.0-tcl-install.patch
	epatch "${FILESDIR}"/${PN}-5.6.0-boost-property_map.patch
	epatch "${FILESDIR}"/${PN}-5.6.0-libpng14.patch
	epatch "${FILESDIR}"/${PN}-5.6.0-R.patch
	epatch "${FILESDIR}"/${PN}-5.6.0-odbc.patch
	# Fix sure buffer overflow on some processors as reported by Flameyes in #338819
	sed -e "s:CHIPNAME_STRING_LENGTH    (48 + 1):CHIPNAME_STRING_LENGTH    (79 + 1):" \
		-i Utilities/kwsys/SystemInformation.cxx \
		|| die "Failed to fix SystemInformation.cxx buffer overflow"
	sed -e "s:@VTK_TCL_LIBRARY_DIR@:/usr/$(get_libdir):" \
		-i Wrapping/Tcl/pkgIndex.tcl.in \
		|| die "Failed to fix tcl pkgIndex file"
	# Remove FindPythonLibs.cmake to use the patched one from cmake
	rm CMake/FindPythonLibs.cmake
}

src_configure() {
	# general configuration
	local mycmakeargs=(
		-Wno-dev
		-DVTK_INSTALL_PACKAGE_DIR=/$(get_libdir)/${PN}-${SPV}
		-DCMAKE_SKIP_RPATH=YES
		-DVTK_DIR="${S}"
		-DVTK_INSTALL_LIB_DIR=/$(get_libdir)/
		-DVTK_DATA_ROOT:PATH="${EPREFIX}"/usr/share/${PN}/data
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}"/usr
		-DBUILD_SHARED_LIBS=ON
		-DVTK_USE_SYSTEM_EXPAT=ON
		-DVTK_USE_SYSTEM_FREETYPE=ON
		-DVTK_USE_SYSTEM_JPEG=ON
		-DVTK_USE_SYSTEM_LIBXML2=ON
		-DVTK_USE_SYSTEM_PNG=ON
		-DVTK_USE_SYSTEM_TIFF=ON
		-DVTK_USE_SYSTEM_ZLIB=ON
		-DBUILD_TESTING=OFF
		-DBUILD_EXAMPLES=OFF
		-DVTK_USE_HYBRID=ON
		-DVTK_USE_GL2PS=ON
		-DVTK_USE_RENDERING=ON)

	# use flag triggered options
	mycmakeargs+=(
		$(cmake-utils_use boost VTK_USE_BOOST)
		$(cmake-utils_use cg VTK_USE_CG_SHADERS)
		$(cmake-utils_use doc DOCUMENTATION_HTML_HELP)
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use java VTK_USE_JAVA)
		$(cmake-utils_use mpi VTK_USE_MPI)
		$(cmake-utils_use patented VTK_USE_PATENTED)
		$(cmake-utils_use qt4 VTK_USE_QT)
		$(cmake-utils_use tcl VTK_WRAP_TCL)
		$(cmake-utils_use theora VTK_USE_OGGTHEORA_ENCODER)
		$(cmake-utils_use ffmpeg VTK_USE_FFMPEG_ENCODER)
		$(cmake-utils_use tk VTK_USE_TK)
		$(cmake-utils_use threads VTK_USE_PARALLEL)
		$(cmake-utils_use R VTK_USE_GNU_R)
		$(cmake-utils_use mysql VTK_USE_MYSQL)
		$(cmake-utils_use postgres VTK_USE_POSTGRES)
		$(cmake-utils_use odbc VTK_USE_ODBC) )

	use theora &&
	mycmakeargs+=(-DVTK_USE_SYSTEM_OGGTHEORA=ON)

	# mpi needs the parallel framework
	if use mpi && use !threads; then
		mycmakeargs+=(-DVTK_USE_PARALLEL=ON)
	fi

	if use java; then
		mycmakeargs+=(
			-DVTK_WRAP_JAVA=ON
			-DJAVA_AWT_INCLUDE_PATH=`java-config -O`/include
			-DJAVA_INCLUDE_PATH:PATH=`java-config -O`/include
			-DJAVA_INCLUDE_PATH2:PATH=`java-config -O`/include/linux)

		if [ "${ARCH}" == "amd64" ]; then
			mycmakeargs+=(-DJAVA_AWT_LIBRARY=`java-config -O`/jre/lib/${ARCH}/libjawt.so)
		else
			mycmakeargs+=(-DJAVA_AWT_LIBRARY:PATH=`java-config -O`/jre/lib/i386/libjawt.so)
		fi
	fi

	if use python; then
		mycmakeargs+=(
			-DVTK_WRAP_PYTHON=ON
			-DPYTHON_INCLUDE_PATH=$(python_get_includedir)
			-DPYTHON_LIBRARY=$(python_get_library)
			-DVTK_PYTHON_SETUP_ARGS:STRING=--root="${D}")
	fi

	if use qt4 ; then
		mycmakeargs+=(
			-DVTK_USE_GUISUPPORT=ON
			-DVTK_USE_QVTK=ON
			-DVTK_USE_QVTK_QTOPENGL=ON
			-DQT_WRAP_CPP=ON
			-DQT_WRAP_UI=ON
			-DVTK_INSTALL_QT_DIR=/$(get_libdir)/qt4/plugins/${PN}
			-DDESIRED_QT_VERSION=4
			-DQT_MOC_EXECUTABLE="${EPREFIX}"/usr/bin/moc
			-DQT_UIC_EXECUTABLE="${EPREFIX}"/usr/bin/uic
			-DQT_INCLUDE_DIR="${EPREFIX}"/usr/include/qt4
			-DQT_QMAKE_EXECUTABLE="${EPREFIX}"/usr/bin/qmake)
	fi

	cmake-utils_src_configure
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
		dodir /usr/share/${PN} || \
			die "Failed to create data/examples directory"

		cp -pPR "${S}"/Examples "${D}"/usr/share/${PN}/examples || \
			die "Failed to copy example files"

		# fix example's permissions
		find "${D}"/usr/share/${PN}/examples -type d -exec \
			chmod 0755 {} \; || \
			die "Failed to fix example directories permissions"
		find "${D}"/usr/share/${PN}/examples -type f -exec \
			chmod 0644 {} \; || \
			die "Failed to fix example files permissions"

		cp -pPR "${WORKDIR}"/VTKData "${D}"/usr/share/${PN}/data || \
			die "Failed to copy data files"

		# fix data's permissions
		find "${D}"/usr/share/${PN}/data -type d -exec \
			chmod 0755 {} \; || \
			die "Failed to fix data directories permissions"
		find "${D}"/usr/share/${PN}/data -type f -exec \
			chmod 0644 {} \; || \
			die "Failed to fix data files permissions"
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
	echo "VTK_DATA_ROOT=/usr/share/${PN}/data" >> "${T}"/40${PN}
	echo "VTK_DIR=/usr/$(get_libdir)/${PN}-${SPV}" >> "${T}"/40${PN}
	echo "VTKHOME=/usr" >> "${T}"/40${PN}
	doenvd "${T}"/40${PN}
}

pkg_postinst() {
	if use patented; then
		ewarn "Using patented code in VTK may require a license."
		ewarn "For more information, please read:"
		ewarn "http://public.kitware.com/cgi-bin/vtkfaq?req=show&file=faq07.005.htp"
	fi

	if use python; then
		python_mod_optimize vtk
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup vtk
	fi
}
