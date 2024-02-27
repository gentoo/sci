EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake fortran-2

DESCRIPTION="CERN program library for High Energy Physics"
HOMEPAGE="https://cernlib.web.cern.ch/cernlib/"
SRC_URI="https://cernlib.web.cern.ch/download/2023_source/tar/${P}-free.tar.gz"
S="${WORKDIR}/${P}-free"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	x11-libs/motif:0
	x11-libs/libXaw
	x11-libs/libXau
	virtual/lapack
	dev-lang/cfortran
	x11-libs/xbae
	net-libs/libnsl
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/$P-cfortran.patch
	"${FILESDIR}"/$P-ctest.patch
	"${FILESDIR}"/$P-man.patch
)
src_prepare() {
	cmake_src_prepare
	rm cfortran/cfortran.h || die
}

src_configure() {
	sed -i "s#/doc/#/doc/${PF}/#g" CMakeLists.txt || die
	cmake_src_configure
}

src_install() {
	cmake_src_install

	doman contrib/man/man1/*.1
	doman contrib/man/man8/*.8
}
