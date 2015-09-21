# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

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
IUSE="debug doc examples fftw itkv3compat python review cpu_flags_x86_sse2 test vtkglue"

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
	"${FILESDIR}"/0001-BUG-Wrap-TransformFileReader-TransformFileWriter.patch
	"${FILESDIR}"/0002-COMP-Fixed-itkQuasiNewtonOptimizerv4-wrapping-warnin.patch
	"${FILESDIR}"/0003-COMP-Fixed-itkGradientDescentOptimizerv4-wrapping-wa.patch
	"${FILESDIR}"/0004-COMP-Warp-OptimizerParameterScalesEstimatorTemplate.patch
	"${FILESDIR}"/0005-make-gdcm-helper-library-static.patch
	"${FILESDIR}"/nrrdio-linking.patch
)

pkg_pretend() {
	if [[ -z ${ITK_COMPUTER_MEMORY_SIZE} ]]; then
		elog "To tune ITK to make the best use of working memory you can set"
		elog "    ITK_COMPUTER_MEMORY_SIZE=XX"
		elog "in make.conf, default is 1 (unit is GB)"
	fi
	if use python && [[ -z ${ITK_WRAP_DIMS} ]]; then
		elog "For Python language bindings, you can define the dimensions"
		elog "you want to create bindings for by setting"
		elog "    ITK_WRAP_DIMS=X;Y;Z..."
		elog "in make.conf, default is 2;3 for 2D and 3D data"
	fi
}

src_configure() {
	sed -i \
		-e '/find_package/d' \
		Modules/ThirdParty/DoubleConversion/CMakeLists.txt || die

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DITK_USE_SYSTEM_DCMTK=ON
		-DITK_USE_SYSTEM_DOUBLECONVERSION=ON
		-DITK_USE_SYSTEM_GCCXML=ON
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_PNG=ON
		-DITK_USE_SYSTEM_SWIG=ON
		-DITK_USE_SYSTEM_TIFF=ON
		-DITK_USE_SYSTEM_ZLIB=ON
		-DITK_BUILD_DEFAULT_MODULES=ON
		-DITK_COMPUTER_MEMORY_SIZE="${ITK_COMPUTER_MEMORY_SIZE:-1}"
		-DWRAP_ITK_JAVA=OFF
		-DWRAP_ITK_TCL=OFF
		-Ddouble-conversion_INCLUDE_DIRS="${EPREFIX}/usr/include/double-conversion"
		-Ddouble-conversion_LIBRARIES="-ldouble-conversion"
		$(cmake-utils_use_build test TESTING)
		$(cmake-utils_use_build examples EXAMPLES)
		$(cmake-utils_use review ITK_USE_REVIEW)
		$(cmake-utils_use itkv3compat ITKV3_COMPATIBILITY)
		$(cmake-utils_use cpu_flags_x86_sse2 VNL_CONFIG_ENABLE_SSE2)
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
	if use vtkglue; then
		mycmakeargs+=(
			-DModule_ITKVtkGlue=ON
		)
	fi
	if use python; then
		mycmakeargs+=(
			-DITK_WRAP_PYTHON=ON
			-DITK_WRAP_DIMS="${ITK_WRAP_DIMS:-2;3}"
		)
	else
		mycmakeargs+=(
			-DITK_WRAP_PYTHON=OFF
		)
	fi
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
}
