# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake

MY_PN="ANTs"

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="https://stnava.github.io/ANTs/"
SRC_URI="
	https://github.com/ANTsX/ANTs/archive/v${PV}.tar.gz ->  ${P}.tar.gz
	test? (
		https://resources.chymera.eu/distfiles/ants_testdata-${PV}.tar.xz
	)
"
S="${WORKDIR}/${MY_PN}-${PV}"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test vtk"
RESTRICT="!test? ( test )"

DEPEND="
	!vtk? ( =sci-libs/itk-5.2*[fftw,-vtkglue] )
	vtk? (
		=sci-libs/itk-5.2*[fftw,vtkglue]
		=sci-libs/vtk-9.1*
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-fix-compile.patch"
)

src_unpack() {
	default
	if use test; then
		mkdir -p "${S}/.ExternalData/SHA512" || die "Could not create test data directory."
		tar xvf "${DISTDIR}/ants_testdata-${PV}.tar.xz" -C "${S}/.ExternalData/SHA512/" > /dev/null || die "Could not unpack test data."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=OFF
		-DUSE_SYSTEM_ITK=ON
		-DITK_USE_SYSTEM_FFTW=ON
		-DITK_DIR="${EPREFIX}/usr/include/ITK-5.2/"
		-DBUILD_TESTING="$(usex test ON OFF)"
		-DUSE_VTK=$(usex vtk ON OFF)
		-DUSE_SYSTEM_VTK=$(usex vtk ON OFF)
	)
	use vtk && mycmakeargs+=(
		-DVTK_DIR="${EPREFIX}/usr/include/vtk-9.1/"
	)
	cmake_src_configure
}

src_install() {
	BUILD_DIR="${WORKDIR}/${MY_PN}-${PV}_build/ANTS-build"
	cmake_src_install
	cd "${S}/Scripts" || die "scripts dir not found"
	dobin *.sh
	dodir /usr/$(get_libdir)/ants
	insinto "/usr/$(get_libdir)/ants"
	doins *
	doenvd "${FILESDIR}"/99ants
}
