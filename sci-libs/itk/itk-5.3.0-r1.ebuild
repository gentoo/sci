# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
VIRTUALX_REQUIRED="manual"

inherit cmake python-single-r1 virtualx

MY_PN="InsightToolkit"
MY_P="${MY_PN}-${PV}"
GLI_V="1.2.0"
IAD_HASH="24825c8d246e941334f47968553f0ae388851f0c"
TEST_HASH="bb6d3b9a932333901465c75417fe8859124f5fed"
declare -a GLI_TEST_HASHES=(
	"a5e11ea71164ff78c65fcf259db01ea5db981a9d868e60045ff2bffca92984df1174bf984a1076e450f0d5d69b4f0191ed1a61465c220e2c91a893b5df150c0a"
	"bcdbb347f3704262d1f00be7179d6a0a6e68aed56c0653e8072ee5a94985c713bd229c935b1226a658af84fb7f1fffc2458c98364fc35303a2303b12f9f7ce2f"
)

GLI_TEST_SRC=""
for i in "${GLI_TEST_HASHES[@]}"; do
	GLI_TEST_SRC+="https://data.kitware.com/api/v1/file/hashsum/sha512/${i}/download -> ${PN}-test-${i} "
done

DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="https://itk.org"
SRC_URI="
	https://github.com/InsightSoftwareConsortium/ITK/releases/download/v${PV}/${MY_P}.tar.gz
	https://github.com/InsightSoftwareConsortium/ITKGenericLabelInterpolator/archive/refs/tags/v${GLI_V}.tar.gz -> ITKGenericLabelInterpolator-${GLI_V}.tar.gz
	https://github.com/ntustison/ITKAdaptiveDenoising/archive/${IAD_HASH}.tar.gz -> ITKAdaptiveDenoising-${PV}.tar.gz
	test? (
		https://github.com/InsightSoftwareConsortium/ITK/releases/download/v${PV}/InsightData-${PV}.tar.gz
		https://github.com/InsightSoftwareConsortium/ITKTestingData/archive/${TEST_HASH}.tar.gz -> ${P}-testingdata.tar.gz
		${GLI_TEST_SRC}
		)
	"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples fftw itkv4-compat python review test vtkglue"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/eigen:3
	dev-libs/double-conversion:0=
	dev-libs/expat:0=
	dev-libs/icu:0=
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:0=
	media-libs/openjpeg:2
	media-libs/tiff:0=[jpeg]
	sci-libs/dcmtk:0=
	sci-libs/gdcm:0=
	sci-libs/hdf5:0=[cxx]
	sys-libs/zlib-ng
	fftw? ( sci-libs/fftw:3.0=[threads] )
	vtkglue? (
		sci-libs/vtk:0=[rendering]
		python? (
			sci-libs/vtk:0=[python,${PYTHON_SINGLE_USEDEP}]
		)
	)
	python? ( ${PYTHON_DEPS} )
"
# Might also need:
# dev-libs/kwsys::guru
# kwiml
# minc
# metaio
# niftilib
# sci-lib/vxl::science
DEPEND="${RDEPEND}
	sys-apps/coreutils
	python? (
		>=dev-lang/swig-2.0:0
		dev-libs/castxml
	)
	doc? ( app-text/doxygen )
"
BDEPEND="
	test? (
		vtkglue? ( ${VIRTUALX_DEPEND} )
		python? (
			$(python_gen_cond_dep 'dev-python/numpy[${PYTHON_USEDEP}]')
		)
	)
"

S="${WORKDIR}/${MY_P}"

# uint patch applied by upstream for next release.
PATCHES=(
	"${FILESDIR}/${PN}-5.2.1-system-tiff-has-64.patch"
	"${FILESDIR}/${PN}-5.3.0-system-openjpeg.patch"
	"${FILESDIR}/${PN}-5.3.0-uint8.patch"
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

src_prepare() {
	# drop bundled libs
	local -a DROPS=(
		DoubleConversion/src/double-conversion
		Eigen3/src/itkeigen
		Expat/src/expat
		GDCM/src/gdcm
		JPEG/src/itkjpeg
		HDF5/src/itkhdf5
		OpenJPEG/src/openjpeg
		PNG/src/itkpng
		TIFF/src/itktiff
		ZLIB/src/itkzlib-ng
	)
	local x
	for x in "${DROPS[@]}"; do
		ebegin "Dropping bundled ${x%%/*}"
		rm -r "Modules/ThirdParty/${x}" || die
		eend $?
	done
	{
		find Modules/ThirdParty -mindepth 2 -maxdepth 2 -type d -name src -printf '%P\n'
		printf '%s\n' "${DROPS[@]}" | sed 's,/[^/]*$,,'
	} | sort | uniq -u | xargs -n 1 ewarn "Using bundled" || die

	# Remote modules
	ln -sr "../ITKGenericLabelInterpolator-${GLI_V}" Modules/External/ITKGenericLabelInterpolator || die
	ln -sr "../ITKAdaptiveDenoising-${IAD_HASH}" Modules/External/ITKAdaptiveDenoising || die

	cmake_src_prepare

	if use test; then
		cp -rf "../ITKTestingData-${TEST_HASH}/"* ".ExternalData/" || die
		mv "../ITKTestingData-${TEST_HASH}" "${BUILD_DIR}/.ExternalData" || die
		for i in "${GLI_TEST_HASHES[@]}"; do
			cp "${DISTDIR}/${PN}-test-${i}" ".ExternalData/SHA512/${i}" || die
			cp "${DISTDIR}/${PN}-test-${i}" "${BUILD_DIR}/.ExternalData/SHA512/${i}" || die
		done
	fi
}

src_configure() {
	local mycmakeargs=(
		-DITK_BUILD_DOCUMENTATION="$(usex doc ON OFF)"
		-DITK_INSTALL_DOC_DIR="share/doc/${P}"
		-DBUILD_EXAMPLES="$(usex examples ON OFF)"
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING="$(usex test ON OFF)"
		-Ddouble-conversion_INCLUDE_DIRS="${EPREFIX}/usr/include/double-conversion"
		-DExternalData_OBJECT_STORES="${WORKDIR}/InsightToolkit-${PV}/.ExternalData"
		-DGDCM_USE_SYSTEM_OPENJPEG=ON
		-DITK_FORBID_DOWNLOADS:BOOL=ON
		-DITK_INSTALL_LIBRARY_DIR=$(get_libdir)
		-DITK_USE_REVIEW="$(usex review ON OFF)"
		-DITK_USE_SYSTEM_ICU=ON
		-DITK_USE_SYSTEM_DCMTK=ON
		-DITK_USE_SYSTEM_DOUBLECONVERSION=ON
		-DITK_USE_SYSTEM_CASTXML=ON
		-DITK_USE_SYSTEM_EIGEN=ON
		-DITK_USE_SYSTEM_EXPAT=ON
		-DITK_USE_SYSTEM_GDCM=ON
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_OPENJPEG=ON
		-DITK_USE_SYSTEM_PNG=ON
		-DITK_USE_SYSTEM_SWIG=ON
		-DITK_USE_SYSTEM_TIFF=ON
		-DITK_USE_SYSTEM_ZLIB=ON
		-DITK_USE_KWSTYLE=OFF
		-DITK_BUILD_DEFAULT_MODULES=ON
		-DITK_COMPUTER_MEMORY_SIZE="${ITK_COMPUTER_MEMORY_SIZE:-1}"
		-DModule_AdaptiveDenoising:BOOL=ON
		-DModule_GenericLabelInterpolator:BOOL=ON
		-DModule_ITKReview:BOOL=ON
		-DWRAP_ITK_JAVA=OFF
		-DWRAP_ITK_TCL=OFF
		-DITKV4_COMPATIBILITY:BOOL=$(usex itkv4-compat)
	)
	if use fftw; then
		mycmakeargs+=(
			-DITK_USE_FFTWD:BOOL=ON
			-DITK_USE_FFTWF:BOOL=ON
			-DITK_USE_SYSTEM_FFTW:BOOL=ON
			-DITK_WRAP_double=ON
			-DITK_WRAP_vector_double=ON
			-DITK_WRAP_covariant_vector_double=ON
			-DITK_WRAP_complex_double=ON
		)
	else
		mycmakeargs+=(
			-DITK_USE_FFTWD:BOOL=OFF
			-DITK_USE_FFTWF:BOOL=OFF
			-DITK_USE_SYSTEM_FFTW:BOOL=OFF
			-DITK_WRAP_double=OFF
			-DITK_WRAP_vector_double=OFF
			-DITK_WRAP_covariant_vector_double=OFF
			-DITK_WRAP_complex_double=OFF
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
			-DPython3_EXECUTABLE="${PYTHON}"
			-DITK_WRAP_DIMS="${ITK_WRAP_DIMS:-2;3}"
		)
	else
		mycmakeargs+=(
			-DITK_WRAP_PYTHON=OFF
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		docinto examples
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r "${S}"/Examples/*
	fi

	echo "ITK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data" > ${T}/40${PN} || die
	local ldpath="${EPREFIX}/usr/$(get_libdir)/InsightToolkit"
	if use python; then
		echo "PYTHONPATH=${EPREFIX}/usr/$(get_libdir)/InsightToolkit/WrapITK/Python" >> "${T}"/40${PN} || die
		ldpath="${ldpath}:${EPREFIX}/usr/$(get_libdir)/InsightToolkit/WrapITK/lib"
	fi
	echo "LDPATH=${ldpath}" >> "${T}"/40${PN} || die
	doenvd "${T}"/40${PN}

	if use doc; then
		cd "${WORKDIR}"/html || die
		rm  *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		docinto api-docs
		dodoc -r *
	fi

	use python && python_optimize
}

src_test() {
	if use vtkglue; then
		virtx cmake_src_test
	else
		cmake_src_test
	fi
}
