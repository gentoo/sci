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
"
S="${WORKDIR}/${MY_PN}-${PV}"

SLOT="0"
LICENSE="BSD"
# Fails on account of not finding a source file:
# https://ppb.chymera.eu/e8dcb1.log
KEYWORDS=""
IUSE="test vtk"
RESTRICT="test"

DEPEND="
	=sci-libs/itk-5.2*
	vtk? (
		=sci-libs/itk-5.2*[vtkglue]
		=sci-libs/vtk-9.1*
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_ITK=ON
		-DITK_DIR="${EPREFIX}/usr/include/ITK-5.2/"
		-DBUILD_TESTING="$(usex test ON OFF)"
		-DUSE_VTK=$(usex vtk ON OFF)
		-DUSE_SYSTEM_VTK=$(usex vtk ON OFF)
		-DANTS_SNAPSHOT_VERSION:STRING=${PV}
	)
	use vtk && mycmakeargs+=(
		-DVTK_DIR="${EPREFIX}/usr/include/vtk-9.1/"
	)
	cmake_src_configure
}

src_install() {
	BUILD_DIR="${WORKDIR}/${P}_build/ANTS-build"
	cmake_src_install
	cd "${S}/Scripts" || die "scripts dir not found"
	dobin *.sh
	dodir /usr/$(get_libdir)/ants
	insinto "/usr/$(get_libdir)/ants"
	doins *
	doenvd "${FILESDIR}"/99ants
}
