# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit cmake python-single-r1

DESCRIPTION="Cross-platform DICOM implementation"
HOMEPAGE="http://gdcm.sourceforge.net/"
SRC_URI="mirror://sourceforge/gdcm/${P}.tar.bz2
	test? ( mirror://sourceforge/gdcm/gdcmData.tar.gz )" # 3.0.14: .bz2 is broken, should be checked in next release

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc python test vtk"
RESTRICT="!test? ( test )"

DEPEND="
	app-text/poppler:0=[cxx]
	dev-libs/expat:0=
	dev-libs/json-c:0=
	dev-libs/libxml2:2=
	dev-libs/openssl:0=
	>=media-libs/charls-2.0.0:0=
	>=media-libs/openjpeg-2.0.0:2=
	sys-apps/util-linux:0=
	sys-libs/zlib:0=
	python? ( ${PYTHON_DEPS} )
	vtk? (
		sci-libs/vtk[rendering]
		python? (
			sci-libs/vtk[python,${PYTHON_SINGLE_USEDEP}]
		)
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/libxslt
	app-text/docbook-xsl-ns-stylesheets
	doc? ( app-doc/doxygen[dot] )
	python? (
		${PYTHON_DEPS}
		>=dev-lang/swig-3.0.7
	)"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/gdcm_support_vtk9.patch"
	"${FILESDIR}/gdcm-3.0.14-include-math-h.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	# drop unbundled libs
	local -a DROPS=( gdcmcharls gdcmexpat gdcmopenjpeg gdcmuuid gdcmzlib getopt pvrg KWStyle Release )
	local x
	for x in "${DROPS[@]}"; do
		ebegin "Dropping bundled ${x#gdcm}"
		rm -r "Utilities/${x}" || die
		sed -i "s,^[ \t]*APPEND_COPYRIGHT(\\\${CMAKE_CURRENT_SOURCE_DIR}/${x}/,#&," "Utilities/CMakeLists.txt" || die
		eend $?
	done
	find Utilities -mindepth 1 -maxdepth 1 '!' -name doxygen '!' -name VTK -type d \
		-exec ewarn "Using bundled" {} ';' || die

	# fix charls include case
	sed -i 's:CharLS/charls\.h:charls/charls.h:' CMake/FindCharLS.cmake Utilities/gdcm_charls.h || die
	sed -i 's:NAMES CharLS:NAMES charls:' CMake/FindCharLS.cmake || die

	# Use prefixed socket++ (to avoid potential conflicts)
	sed -i '/target_link_libraries(/s/socketxx/gdcm&/' \
		Source/MessageExchangeDefinition/CMakeLists.txt \
		Applications/Cxx/CMakeLists.txt \
		|| die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DGDCM_BUILD_SHARED_LIBS=ON
		-DGDCM_DATA_ROOT="${WORKDIR}/gdcmData"
		-DGDCM_INSTALL_LIB_DIR="$(get_libdir)"
		-DGDCM_INSTALL_DOC_DIR="share/doc/${P}"
		-DGDCM_INSTALL_PYTHONMODULE_DIR="lib/${EPYTHON}/site-packages"
		-DGDCM_USE_SYSTEM_ZLIB=ON
		-DGDCM_USE_SYSTEM_OPENSSL=ON
		-DGDCM_USE_SYSTEM_UUID=ON
		-DGDCM_USE_SYSTEM_EXPAT=ON
		-DGDCM_USE_SYSTEM_JSON=ON
		-DGDCM_USE_SYSTEM_PAPYRUS3=OFF
		-DGDCM_USE_SYSTEM_SOCKETXX=OFF
		-DSOCKETXX_NAMESPACE=GDCMSOCKETXX
		-DGDCM_USE_SYSTEM_LJPEG=OFF
		-DGDCM_USE_SYSTEM_OPENJPEG=ON
		-DGDCM_USE_SYSTEM_CHARLS=ON
		-DGDCM_USE_SYSTEM_POPPLER=ON
		-DGDCM_USE_SYSTEM_LIBXML2=ON
		-DGDCM_BUILD_TESTING=$(usex test)
		-DGDCM_WRAP_PYTHON=$(usex python)
		$(usex python "-DGDCM_DEFAULT_PYTHON_VERSION=${EPYTHON#python}" "")
		-DGDCM_WRAP_PERL=OFF
		-DGDCM_WRAP_PHP=OFF
		-DGDCM_WRAP_JAVA=OFF
		-DGDCM_WRAP_CSHARP=OFF
		-DGDCM_DOCUMENTATION=$(usex doc)
		$(usex doc "-DGDCM_PDF_DOCUMENTATION=OFF" "")
		-DGDCM_BUILD_EXAMPLES=OFF
		-DGDCM_BUILD_APPLICATIONS=ON
		-DGDCM_USE_VTK=$(usex vtk)
	)
	cmake_src_configure
}
