# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit eutils toolchain-funcs cmake-utils python-single-r1

MYPN=InsightToolkit
MYP=${MYPN}-${PV}
DOC_PV=4.5.0

DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="http://www.itk.org"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.xz
	doc? ( mirror://sourceforge/${PN}/Doxygen${MYPN}-${DOC_PV}.tar.gz )"
RESTRICT="primaryuri"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug doc examples +fftw itkv3compat python review cpu_flags_x86_sse2 test vtkglue"

RDEPEND="
	dev-libs/double-conversion:0=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sci-libs/dcmtk:0=
	sci-libs/hdf5:0=[cxx]
	sys-libs/zlib:0=
	virtual/jpeg:0=
	fftw? ( sci-libs/fftw:3.0= )
	vtkglue? ( sci-libs/vtk:0=[python?] )
"
DEPEND="${RDEPEND}
	python? (
		${PYTHON_DEPS}
		>=dev-lang/swig-2.0:0
		>=dev-cpp/gccxml-0.9.0_pre20120309
	)
	doc? ( app-doc/doxygen )
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MYP}"

PATCHES=(
	"${FILESDIR}/nrrdio-linking.patch"
)

get_memory() {
	free --giga | grep Mem | cut -d ' ' -f 15 || die 'unable to get memory size'
}

src_configure() {
	sed -i \
		-e '/find_package/d' \
		Modules/ThirdParty/DoubleConversion/CMakeLists.txt || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DITK_USE_SYSTEM_DCMTK=ON
		-DITK_USE_SYSTEM_DOUBLECONVERSION=ON
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_PNG=ON
		-DITK_USE_SYSTEM_SWIG=ON
		-DITK_USE_SYSTEM_TIFF=ON
		-DITK_USE_SYSTEM_ZLIB=ON
		-DITK_BUILD_DEFAULT_MODULES=ON
		-DITK_COMPUTER_MEMORY_SIZE="$(get_memory)"
		-DITK_WRAP_JAVA=OFF
		-DITK_WRAP_TCL=OFF
		-DBUILD_TESTING=$(usex test)
		-DBUILD_EXAMPLES=$(usex examples)
		-DITK_USE_REVIEW=$(usex review)
		-DITKV3_COMPATIBILITY=$(usex itkv3compat)
		-DVNL_CONFIG_ENABLE_SSE2=$(usex cpu_flags_x86_sse2)
	)
	if use fftw; then
		mycmakeargs+=(
			-DUSE_FFTWD=ON
			-DUSE_FFTWF=ON
			-DUSE_SYSTEM_FFTW=ON
			-DITK_USE_SYSTEM_FFTW=ON
			-DITK_WRAPPING=ON
			-DITK_WRAP_double=ON
			-DITK_WRAP_vector_double=ON
			-DITK_WRAP_covariant_vector_double=ON
			-DITK_WRAP_complex_double=ON
		)
	fi
	if use vtkglue; then
		mycmakeargs+=(
			-DModule_ITKVtkGlue=ON
		)
	fi
	mycmakeargs+=(
		-DITK_WRAP_PYTHON=$(usex python ON OFF)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		docompress -x /usr/share/doc/${PF}/examples
		doins -r "${S}"/Examples/*
	fi

	echo "ITK_DATA_ROOT=${EROOT%/}/usr/share/${PN}/data" > ${T}/40${PN}
	local ldpath="${EROOT%/}/usr/$(get_libdir)/InsightToolkit"
	if use python; then
		echo "PYTHONPATH=${EROOT%/}/usr/$(get_libdir)/InsightToolkit/WrapITK/Python" >> "${T}"/40${PN}
		ldpath="${ldpath}:${EROOT%/}/usr/$(get_libdir)/InsightToolkit/WrapITK/lib"
	fi
	echo "LDPATH=${ldpath}" >> "${T}"/40${PN}
	doenvd "${T}"/40${PN}

	if use doc; then
		insinto /usr/share/doc/${PF}/api-docs
		cd "${WORKDIR}"/html
		rm  *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		insinto /usr/share/doc/${PF}/api-docs
		doins -r *
	fi

	mv "${D}/usr/lib" "${D}/usr/$(get_libdir)" || \
		die 'unable to fix libdir'
}
