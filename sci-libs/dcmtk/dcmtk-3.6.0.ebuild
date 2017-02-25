# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils

DESCRIPTION="OFFIS DICOM image files library and tools"
HOMEPAGE="http://dicom.offis.de/dcmtk.php.en"
SRC_URI="
	http://dicom.offis.de/download/dcmtk/release/${P}.tar.gz
	https://raw.githubusercontent.com/gentoo-science/sci/master/patches/07_doxygen.patch
	"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="doc png ssl tcpd +threads tiff xml zlib"

RDEPEND="
	virtual/jpeg:0=
	png? ( media-libs/libpng:0= )
	ssl? ( dev-libs/openssl:= )
	tcpd? ( sys-apps/tcp-wrappers )
	tiff? ( media-libs/tiff:0= )
	xml? ( dev-libs/libxml2:2= )
	zlib? ( sys-libs/zlib:0= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )"

PATCHES=(
	"${FILESDIR}"/${PN}-asneeded.patch
	"${FILESDIR}"/02_dcmtk_3.6.0-1.patch
	"${DISTDIR}"/07_doxygen.patch
	"${FILESDIR}"/prefs.patch
	"${FILESDIR}"/dcmtk_version_number.patch
	"${FILESDIR}"/regression_stacksequenceisodd.patch
	"${FILESDIR}"/bug674361.patch
	"${FILESDIR}"/use_correct_number_of_TS.patch
	"${FILESDIR}"/fixnull.patch
	"${FILESDIR}"/nothrow.patch
	"${FILESDIR}"/noleak.patch
	"${FILESDIR}"/doubledes.patch
)

src_prepare() {
	sed -i \
		-e "s:/usr/local/bin:$(type -P perl):g" \
		dcmwlm/perl/*.pl || die
	sed -i \
		-e "s:share/doc/dcmtk:share/doc/${PF}:" \
		-e "s:/lib\":/$(get_libdir)\":" \
		-e "s:COPYRIGHT::" \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		$(cmake-utils_use doc DCMTK_WITH_DOXYGEN)
		$(cmake-utils_use png DCMTK_WITH_PNG)
		$(cmake-utils_use ssl DCMTK_WITH_OPENSSL)
		$(cmake-utils_use threads DCMTK_WITH_THREADS)
		$(cmake-utils_use tiff DCMTK_WITH_TIFF)
		$(cmake-utils_use xml DCMTK_WITH_XML)
		$(cmake-utils_use zlib DCMTK_WITH_ZLIB)
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usex doc "html" "")
}
