# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_DEPEND="2:2.6"

inherit eutils toolchain-funcs cmake-utils

DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="http://www.itk.org"
SRC_URI="mirror://sourceforge/itk/InsightToolkit-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug examples fftw +shared test python hdf5 itkv3compat review patented"

RDEPEND="sys-libs/zlib
	fftw? ( sci-libs/fftw )
	hdf5?  ( sci-libs/hdf5[cxx] )
		virtual/jpeg
		media-libs/libpng
		media-libs/tiff:0
		sys-libs/zlib
		"
DEPEND="${RDEPEND}
		  >=dev-util/cmake-2.8
	python? ( >=dev-lang/python-2.5 >=dev-lang/swig-2.0 >=dev-cpp/gccxml-0.9.0_pre20120309 )
	"

MY_PN=InsightToolkit
S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	epatch "${FILESDIR}/itk-4.4-v3compat_I2VI_const-fix.patch"
}

src_configure() {
	if [ "x$ITK_COMPUTER_MEMORY_SIZE" = "x" ]; then
		ITK_COMPUTER_MEMORY_SIZE=4
	fi
	if [ "x$ITK_WRAP_DIMS" = "x" ]; then
		ITK_WRAP_DIMS=2,3
	fi

	local mycmakeargs=(
		 -DCMAKE_INSTALL_PREFIX:PATH=/usr
		 -DWRAP_ITK_JAVA=OFF
		 -DWRAP_ITK_TCL=OFF
		 -DITK_USE_SYSTEM_JPEG=ON
		 -DITK_USE_SYSTEM_PNG=ON
		 -DITK_USE_SYSTEM_TIFF=ON
		 -DITK_USE_SYSTEM_ZLIB=ON
		 -DITK_BUILD_ALL_MODULES=ON
		 -DITK_USE_SYSTEM_GCCXML=ON
		 -DITK_USE_SYSTEM_SWIG=ON
		$(cmake-utils_use hdf5 ITK_USE_SYSTEM_HDF5)
		$(cmake-utils_use examples BUILD_EXAMPLES)
		$(cmake-utils_use shared BUILD_SHARED_LIBS)
		$(cmake-utils_use test BUILD_TESTING)
		$(cmake-utils_use review ITK_USE_REVIEW)
		$(cmake-utils_use patented ITK_USE_PATENTED)
		)

	if use itkv3compat; then
		mycmakeargs+=( -DITKV3_COMPATIBILITY=ON  )
	fi

	if use fftw; then
		mycmakeargs+=(
			-DUSE_FFTWD=ON
			-DUSE_FFTWF=ON
			-DUSE_SYSTEM_FFTW=ON
			-DITK_WRAP_double=ON
			-DITK_WRAP_vector_double=ON
			-DITK_WRAP_covariant_vector_double=ON
			-DITK_WRAP_complex_double=ON
			)
	fi

	if use python; then
		mycmakeargs+=( -DITK_WRAP_PYTHON=ON)
	fi

	cmake-utils_src_configure
}

#src_compile() {
#	cd "${WORKDIR}/${PN}-${PV}_build"
#        emake || die "emake failed"
#}

src_install() {

	cmake-utils_src_install

	pushd "${CMAKE_BUILD_DIR}" &> /dev/null

	# install the examples
	if use examples; then
		# Copy Example sources
		rm -rf $(find "Examples" -type d -a -name "CMakeFiles") \; || \
			 die "Failed remove build files"

		dodir /usr/share/${MY_PN}/examples ||	\
			die "Failed to create examples directory"

		pushd "${S}"
		# remove CVS directories from examples folder
		rm -rf $(find "Examples" -type d -name CVS ) ||\
			die "Failed to remove CVS folders"
		cp -pPR "Examples" "${D}/usr/share/${MY_PN}/examples/src" || \
			die "Failed to copy example files"

		popd

		# copy binary examples
		cp -pPR "bin" "${D}/usr/share/${MY_PN}/examples" || \
			die "Failed to copy binary example files"
		rm -rf "${D}"/usr/share/"${MY_PN}"/examples/bin/*.so* || \
			die "Failed to remove libraries from examples directory"

		# fix examples permissions
		find "${D}/usr/share/${MY_PN}/examples/src" -type d -exec	\
			chmod 0755 {} \; ||				\
			die "Failed to fix example directories permissions"
		find "${D}/usr/share/${MY_PN}/examples/src" -type f -exec	\
			chmod 0644 {} \; ||				\
			die "Failed to fix example files permissions"
	fi
	popd

	echo "ITK_DATA_ROOT=/usr/share/${PN}/data" > ${T}/40${PN}

	LDPATH="/usr/lib/InsightToolkit"

	if use python; then
	   echo "PYTHONPATH=/usr/lib/InsightToolkit/WrapITK/Python" >> ${T}/40${PN}
	   LDPATH="${LDPATH}:/usr/lib/InsightToolkit/WrapITK/lib"
		fi
	echo "LDPATH=${LDPATH}" >> $T/40${PN}

	doenvd "${T}/40${PN}"

}

pkg_postinst() {

	if use patented; then
		ewarn "Using patented code in ITK may require a license."
		ewarn "For more information, please read:"
		ewarn "http://www.itk.org/HTML/Copyright.htm"
		ewarn "http://www.itk.org/Wiki/ITK_Patent_Bazaar"
	fi

}
