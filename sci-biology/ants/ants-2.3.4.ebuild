# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake

MY_PN="ANTs"

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="http://stnava.github.io/ANTs/"
SRC_URI="
	https://github.com/ANTsX/ANTs/archive/v${PV}.tar.gz ->  ${P}.tar.gz
	test? (
		http://resources.chymera.eu/distfiles/ants_testdata-${PV}.tar.xz
	)
"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test vtk"
RESTRICT="!test? ( test )"

DEPEND="
	vtk? (
		~sci-libs/itk-5.1.0[vtkglue]
		sci-libs/vtk
	)
	!vtk? (	~sci-libs/itk-5.1.0 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-version.patch"
	"${FILESDIR}/${P}-libdir.patch"
)

S="${WORKDIR}/${MY_PN}-${PV}"

src_unpack() {
	default
	if use test; then
		mkdir -p "${S}/.ExternalData/MD5" || die "Could not create test data directory."
		tar xvf "${DISTDIR}/ants_testdata-${PV}.tar.xz" -C "${S}/.ExternalData/MD5/" > /dev/null || die "Could not unpack test data."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_ITK=ON
		-DITK_DIR="${EPREFIX}/usr/include/ITK-5.1/"
		-DBUILD_TESTING="$(usex test ON OFF)"
		-DUSE_VTK=$(usex vtk ON OFF)
		-DUSE_SYSTEM_VTK=$(usex vtk ON OFF)
		-DANTS_SNAPSHOT_VERSION:STRING=${PV}
	)
	use vtk && mycmakeargs+=(
		-DVTK_DIR="${EPREFIX}/usr/include/vtk-8.1/"
	)
	use test && mycmakeargs+=(
		-DExternalData_OBJECT_STORES="${S}/.ExternalData/MD5"
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
