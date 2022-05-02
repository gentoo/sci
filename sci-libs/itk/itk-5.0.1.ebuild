# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake python-single-r1

MY_PN="InsightToolkit"
MY_P="${MY_PN}-${PV}"
GLI_HASH="187ab99b7d42718c99e5017f0acd3900d7469bd1"
GLI_TEST_HASH="57b5d5de8d777f10f269445a"

DESCRIPTION="NLM Insight Segmentation and Registration Toolkit"
HOMEPAGE="http://www.itk.org"
SRC_URI="
	https://github.com/InsightSoftwareConsortium/ITK/releases/download/v${PV}/${MY_P}.tar.gz
	https://github.com/InsightSoftwareConsortium/ITKGenericLabelInterpolator/archive/${GLI_HASH}.tar.gz -> ITKGenericLabelInterpolator-${PV}.tar.gz
	test? (
		https://data.kitware.com/api/v1/folder/${GLI_TEST_HASH}/download -> ITKGenericLabelInterpolator_test-${PV}.zip
		https://github.com/InsightSoftwareConsortium/ITK/releases/download/v${PV}/InsightData-${PV}.tar.gz
		)
	"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc examples fftw python review test vtkglue"
RESTRICT="!test? ( test )"
# python will not work, this is a know issue upstream:
# https://github.com/InsightSoftwareConsortium/ITK/issues/1229
# https://github.com/InsightSoftwareConsortium/ITKGenericLabelInterpolator/issues/10

RDEPEND="
	dev-libs/double-conversion:0=
	media-libs/openjpeg:2
	media-libs/libpng:0=
	media-libs/tiff:0=
	sci-libs/dcmtk:0=
	sci-libs/hdf5:0=[cxx]
	sys-libs/zlib:0=
	media-libs/libjpeg-turbo:0=
	fftw? ( sci-libs/fftw:3.0= )
	vtkglue? ( sci-libs/vtk:0=[rendering,python?] )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	sys-apps/coreutils
	python? (
		>=dev-lang/swig-2.0:0
		dev-cpp/castxml
	)
	doc? ( app-doc/doxygen )
"
BDEPEND="app-arch/unzip"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/ITKModuleRemote.patch
	"${FILESDIR}"/tests.patch
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
	sed -i -e "s/find_package(OpenJPEG 2.0.0/find_package(OpenJPEG/g"\
		Modules/ThirdParty/GDCM/src/gdcm/CMakeLists.txt
	ln -sr ../ITKGenericLabelInterpolator-* Modules/Remote/ITKGenericLabelInterpolator || die
	if use test; then
		for filename in ../GenericLabelInterpolator/test/*/*mha; do
			MD5=$(md5sum $filename) || die
			MD5=${MD5%  *} || die
			cp "$filename" ".ExternalData/MD5/${MD5}" || die
		done
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DGDCM_USE_SYSTEM_OPENJPEG=ON
		-DITK_FORBID_DOWNLOADS:BOOL=OFF
		-DITK_USE_SYSTEM_DCMTK=ON
		-DITK_USE_SYSTEM_DOUBLECONVERSION=ON
		-DITK_USE_SYSTEM_CASTXML=ON
		-DITK_USE_SYSTEM_HDF5=ON
		-DITK_USE_SYSTEM_JPEG=ON
		-DITK_USE_SYSTEM_PNG=ON
		-DITK_USE_SYSTEM_SWIG=ON
		-DITK_USE_SYSTEM_TIFF=ON
		-DITK_USE_SYSTEM_ZLIB=ON
		-DITK_USE_KWSTYLE=OFF
		-DITK_BUILD_DEFAULT_MODULES=ON
		-DITK_COMPUTER_MEMORY_SIZE="${ITK_COMPUTER_MEMORY_SIZE:-1}"
		-DWRAP_ITK_JAVA=OFF
		-DWRAP_ITK_TCL=OFF
		-Ddouble-conversion_INCLUDE_DIRS="${EPREFIX}/usr/include/double-conversion"
		-DExternalData_OBJECT_STORES="${WORKDIR}/InsightToolkit-${PV}/.ExternalData"
		-DModule_GenericLabelInterpolator:BOOL=ON
		-DModule_ITKReview:BOOL=ON
		-DBUILD_TESTING="$(usex test ON OFF)"
		-DBUILD_EXAMPLES="$(usex examples ON OFF)"
		-DITK_USE_REVIEW="$(usex review ON OFF)"
		-DITK_BUILD_DOCUMENTATION="$(usex doc ON OFF)"
		-DITK_INSTALL_LIBRARY_DIR=$(get_libdir)
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
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		docinto examples
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r "${S}"/Examples/*
	fi

	echo "ITK_DATA_ROOT=${EPREFIX}/usr/share/${PN}/data" > ${T}/40${PN}
	local ldpath="${EPREFIX}/usr/$(get_libdir)/InsightToolkit"
	if use python; then
		echo "PYTHONPATH=${EPREFIX}/usr/$(get_libdir)/InsightToolkit/WrapITK/Python" >> "${T}"/40${PN}
		ldpath="${ldpath}:${EPREFIX}/usr/$(get_libdir)/InsightToolkit/WrapITK/lib"
	fi
	echo "LDPATH=${ldpath}" >> "${T}"/40${PN}
	doenvd "${T}"/40${PN}

	if use doc; then
		cd "${WORKDIR}"/html || die
		rm  *.md5 || die "Failed to remove superfluous hashes"
		einfo "Installing API docs. This may take some time."
		docinto api-docs
		dodoc -r *
	fi
}
