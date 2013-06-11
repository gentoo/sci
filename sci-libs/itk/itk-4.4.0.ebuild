# Copyright 2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit eutils toolchain-funcs cmake-utils  python-single-r1

DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="http://www.itk.org"
SRC_URI="mirror://sourceforge/itk/InsightToolkit-${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="debug examples fftw hdf5 itkv3compat python  review test"

RDEPEND="fftw? ( sci-libs/fftw:3.0 )
	 hdf5? ( sci-libs/hdf5[cxx] )
		virtual/jpeg
		media-libs/libpng
		media-libs/tiff:0
		sys-libs/zlib
		"
DEPEND="${RDEPEND}
	>=dev-util/cmake-2.8
	python? ( ${PYTHON_DEPS}  >=dev-lang/swig-2.0 >=dev-cpp/gccxml-0.9.0_pre20120309 )
	"

MY_PN=InsightToolkit
S="${WORKDIR}/${MY_PN}-${PV}"

PATCHES=(
	"${FILESDIR}/itk-4.4-v3compat_I2VI_const-fix.patch"
)

pkg_pretend() {
	bailout=no
	if [ "x$ITK_COMPUTER_MEMORY_SIZE" = "x" ]; then
		eerror "To tune ITK to make the best use ouf working memory you must set"
		eerror "ITK_COMPUTER_MEMORY_SIZE in /etc/make.conf to the size of the "
		eerror "memory installed in your machine. For example for 4GB you do:"
		eerror ""
		eerror "   echo 'ITK_COMPUTER_MEMORY_SIZE=4' >> /etc/make.conf"
		eerror ""
		bailout=yes
	fi

	if use python ; then
		if [ "x$ITK_WRAP_DIMS" = "x" ]; then
			eerror "For Python language bindings it is necessary to "
			eerror "define the dimensions you want to create bindings for"
			eerror "by setting in ITK_WRAP_DIMS in /etc/make.conf."
			eerror "For example, to provide bindings for 2D and 3D data do:"
			eerror ""
			eerror "  echo 'ITK_WRAP_DIMS=2;3' >> /etc/make.conf"
			eerror ""
			bailout=yes
		fi
	fi
	if [ "x$bailout" = "xyes" ]; then
		die "Please add the missing variables to /etc/make.conf and then restart emerge"
	fi
}

src_configure() {

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
		-DBUILD_SHARED_LIBS=ON
		-DITK_COMPUTER_MEMORY_SIZE="$ITK_COMPUTER_MEMORY_SIZE"
		$(cmake-utils_use_build examples)
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use hdf5 ITK_USE_SYSTEM_HDF5)
		$(cmake-utils_use review ITK_USE_REVIEW)
		$(cmake-utils_use itkv3compat ITKV3_COMPATIBILITY)
		)

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
		mycmakeargs+=(
			-DITK_WRAP_PYTHON=ON
			-DITK_WRAP_DIMS="$ITK_WRAP_DIMS"
		)
	fi

	cmake-utils_src_configure
}

src_install() {

	cmake-utils_src_install

	pushd "${CMAKE_BUILD_DIR}" &> /dev/null

	# install the examples
	if use examples; then
		# Copy Example sources
		rm -rf $(find "Examples" -type d -a -name "CMakeFiles") \; || \
			 die "Failed remove build files"

		dodir /usr/share/${MY_PN}/examples

		pushd "${S}"

		cp -pPR "Examples" "${D}/usr/share/${MY_PN}/examples/src" || \
			die "Failed to copy example files"

		popd

		# copy binary examples
		insinto /usr/share/${MY_PN}/examples
		doins -r bin

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

	echo "ITK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data" > ${T}/40${PN}

	LDPATH="/usr/$(get_libdir)/InsightToolkit"

	if use python; then
		echo "PYTHONPATH=/usr/lib/InsightToolkit/WrapITK/Python" >> ${T}/40${PN}
		LDPATH="${LDPATH}:/usr/lib/InsightToolkit/WrapITK/lib"
	fi
	echo "LDPATH=${LDPATH}" >> $T/40${PN}

	doenvd "${T}/40${PN}"
}
