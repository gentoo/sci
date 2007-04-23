# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# TODO: need to fix Examples/CMakeLists.txt to build other examples

inherit distutils eutils flag-o-matic toolchain-funcs versionator java-pkg-opt-2 python qt3

# Short package version
SPV="$(get_version_component_range 1-2)"

DESCRIPTION="The Visualization Toolkit"
HOMEPAGE="http://www.vtk.org"
SRC_URI="http://www.${PN}.org/files/release/${SPV}/${P}.tar.gz
		examples? ( http://www.${PN}.org/files/release/${SPV}/${PN}data-${PV}.tar.gz )"

LICENSE="BSD LGPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc examples mpi patented python tcl tk threads qt3 qt4"
RDEPEND="java? ( >=virtual/jdk-1.4.2 )
	mpi? ( virtual/mpi )
	python? ( >=dev-lang/python-2.0 )
	tcl? ( >=dev-lang/tcl-8.2.3 )
	tk? ( >=dev-lang/tk-8.2.3 )
	dev-libs/expat
	media-libs/freetype
	media-libs/jpeg
	media-libs/libpng
	media-libs/tiff
	virtual/opengl
	|| ( x11-libs/libXmu virtual/x11 )"

DEPEND="${RDEPEND}
		>=dev-util/cmake-2.2.3
		qt3? ( $(qt_min_version 3.3.4) )
		qt4? ( >=x11-libs/qt-4.1.0 )"

S="${WORKDIR}"/VTK


pkg_setup() {
	java-pkg-opt-2_pkg_setup
	if use qt3 && use qt4; then
		echo
		ewarn "qt3 and qt4 support for vtk are mutually exclusive and"
		ewarn "qt4 support has therefore been enabled by default."
		echo
	fi
}

src_compile() {
	# gcc versions 3.2.x seem to have sse-related bugs that are 
	# triggered by VTK when compiling for pentium3/4
	if [ "$(gcc-major-version)" -eq 3 -a "$(gcc-minor-version)" -eq 2 -a \
		"$(get-flag -march)" == "-march=pentium4" ]; then
		filter-mfpmath sse
		filter-flags "-msse -msse2"
		echo "$(get-flag -march)"
	fi

	# Fix Examples cmake file
	sed -e "s/MAKEPROGRAM/CMAKE_MAKE_PROGRAM/g" \
		-i ${S}/Examples/CMakeLists.txt || \
		die "Failed to fix examples CMakeList.txt"

	# build list of config variable define's to pass to cmake
	local CMAKE_VARIABLES=""
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_SKIP_RPATH:BOOL=YES"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_DIR:PATH=${S}"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DCMAKE_INSTALL_PREFIX:PATH=/usr"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_SHARED_LIBS:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_FREETYPE:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_JPEG:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_PNG:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_TIFF:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_ZLIB:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_SYSTEM_EXPAT:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DBUILD_TESTING:BOOL=OFF"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_HYBRID:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_GL2PS:BOOL=ON"
	CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_RENDERING:BOOL=ON"

	use examples && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_DATA_ROOT:PATH=/usr/share/${PN}/data -DBUILD_EXAMPLES:BOOL=ON"
	if use java; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_WRAP_JAVA:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DJAVA_AWT_INCLUDE_PATH:PATH=`java-config -O`/include"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DJAVA_INCLUDE_PATH:PATH=`java-config -O`/include"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DJAVA_INCLUDE_PATH2:PATH=`java-config -O`/include/linux"
		if [ "${ARCH}" == "amd64" ]; then
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DJAVA_AWT_LIBRARY:PATH=`java-config -O`/jre/lib/${ARCH}/libjawt.so"
		else
			CMAKE_VARIABLES="${CMAKE_VARIABLES} -DJAVA_AWT_LIBRARY:PATH=`java-config -O`/jre/lib/i386/libjawt.so"
		fi
	fi

	if use mpi; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_MPI:BOOL=ON"
		use !threads && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_PARALLEL:BOOL=ON"
	fi

	if use python; then
		python_version
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_WRAP_PYTHON:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPYTHON_INCLUDE_PATH:PATH=/usr/include/python${PYVER}"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DPYTHON_LIBRARY:PATH=/usr/$(get_libdir)/libpython${PYVER}.so"
	fi

	if use qt3 || use qt4 ; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_GUISUPPORT:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_QVTK:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_WRAP_CPP:BOOL=ON"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_WRAP_UI:BOOL=ON"
	fi

	if use qt3; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_INSTALL_QT_DIR:PATH=/qt/3/plugins/${PN}"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DDESIRED_QT_VERSION:STRING=3"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_MOC_EXECUTABLE:FILEPATH=/usr/qt/3/bin/moc"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_UIC_EXECUTABLE:FILEPATH=/usr/qt/3/bin/uic"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_INCLUDE_DIR:PATH=/usr/qt/3/include"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_QMAKE_EXECUTABLE:PATH=/usr/qt/3/bin/qmake"
	fi

	if use qt4; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_INSTALL_QT_DIR:PATH=/$(get_libdir)/qt4/plugins/${PN}"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DDESIRED_QT_VERSION:STRING=4"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_MOC_EXECUTABLE:FILEPATH=/usr/bin/moc"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_UIC_EXECUTABLE:FILEPATH=/usr/bin/uic"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_INCLUDE_DIR:PATH=/usr/include/qt4"
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DQT_QMAKE_EXECUTABLE:PATH=/usr/bin/qmake"
	fi

	if use tcl; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_WRAP_TCL:BOOL=ON"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_WRAP_TCL:BOOL=OFF"
	fi

	if use tk; then
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_TK:BOOL=ON"
	else
		CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_TK:BOOL=OFF"
	fi

	use threads && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_PARALLEL:BOOL=ON"
	use patented && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DVTK_USE_PATENTED:BOOL=ON"
	use doc && CMAKE_VARIABLES="${CMAKE_VARIABLES} -DDOCUMENTATION_HTML_HELP:BOOL=ON -DBUILD_DOCUMENTATION:BOOL=ON"

	# run cmake twice to achieve proper
	# configuration with cmake 2.2.x
	cmake ${CMAKE_VARIABLES} . && cmake ${CMAKE_VARIABLES} . \
		|| die "cmake configuration failed"

	emake -j1 || die "emake failed"
}

src_install() {
	# remove portage paths from dynamically created Type 
	# headers
	sed -e "s:${S}/Common/::" \
		-e "s:${S}/Rendering/::" \
		-i "${S}"/Utilities/InstallOnly/*.cmake || \
		die "Failed to fix cmake files"

	make DESTDIR=${D} install || die "make install failed"

	# install docs
	dohtml "${S}"/README.html || die "Failed to install docs"

	# install python modules
	if use python; then
		cd "${S}"/Wrapping/Python
		docinto vtk_python
		distutils_src_install
	fi

	# install jar
	use java && java-pkg_dojar "${S}"/bin/vtk.jar

	# install Tcl docs
	docinto vtk_tcl
	dodoc "${S}"/Wrapping/Tcl/README || \
		die "Failed to install Tcl docs"

	# install examples
	if use examples; then
		dodir /usr/share/${PN} || \
			die "Failed to create examples directory"
		cp -pPR ${S}/Examples ${D}/usr/share/${PN}/examples || \
			die "Failed to copy example files"

		# fix example's permissions
		find ${D}/usr/share/${PN}/examples -type d -exec \
			chmod 0755 {} \; || \
			die "Failed to fix example directories permissions"
		find ${D}/usr/share/${PN}/examples -type f -exec \
			chmod 0644 {} \; || \
			die "Failed to fix example files permissions"

		cp -pPR ${WORKDIR}/VTKData ${D}/usr/share/${PN}/data || \
			die "Failed to copy data files"

		# fix data's permissions
		find ${D}/usr/share/${PN}/data -type d -exec \
			chmod 0755 {} \; || \
			die "Failed to fix data directories permissions"
		find ${D}/usr/share/${PN}/data -type f -exec \
			chmod 0644 {} \; || \
			die "Failed to fix data files permissions"
	fi

	# environment
	echo "VTK_DATA_ROOT=/usr/share/${PN}/data" >> ${T}/40${PN}
	echo "VTK_DIR=/usr/lib/${PN}-${SPV}" >> ${T}/40${PN}
	if use java; then
		echo "CLASSPATH=/usr/share/${PN}/lib/${PN}.jar" >> ${T}/40${PN}
	fi
	doenvd ${T}/40${PN}
}

pkg_postinst() {
	if use patented; then
		ewarn "Using patented code in VTK may require a license."
		ewarn "For more information, please read:"
		ewarn "http://public.kitware.com/cgi-bin/vtkfaq?req=show&file=faq07.005.htp"
	fi
}
