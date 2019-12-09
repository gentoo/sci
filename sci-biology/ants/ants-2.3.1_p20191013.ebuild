# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"

inherit cmake-utils git-r3 multilib

DESCRIPTION="Advanced Normalitazion Tools for neuroimaging"
HOMEPAGE="http://stnava.github.io/ANTs/"
SRC_URI="
	test? (
		http://chymera.eu/distfiles/ants_testdata-${PV}.tar.xz
	)
"
EGIT_REPO_URI="https://github.com/stnava/ANTs.git"
EGIT_COMMIT="f78b2d4a382d3090230641b5ade5da28962dad04"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test vtk"

DEPEND="
	vtk? (
		~sci-libs/itk-5.0.1[vtkglue]
		sci-libs/vtk
	)
	!vtk? (	~sci-libs/itk-5.0.1 )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-logic.patch"
	"${FILESDIR}/${P}-paths.patch"
)

src_unpack() {
	git-r3_src_unpack
	if use test; then
		mkdir -p "${S}/.ExternalData/MD5" || die "Could not create test data directory."
		tar xvf "${DISTDIR}/ants_testdata-${PV}.tar.xz" -C "${S}/.ExternalData/MD5/" > /dev/null || die "Could not unpack test data."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_ITK=ON
		-DITK_DIR="${EROOT}/usr/include/ITK-5.0/"
		-DBUILD_TESTING="$(usex test ON OFF)"
		-DUSE_VTK=$(usex vtk ON OFF)
		-DUSE_SYSTEM_VTK=$(usex vtk ON OFF)
	)
	use vtk && mycmakeargs+=(
		-DVTK_DIR="${EROOT}/usr/include/vtk-8.1/"
	)
	use test && mycmakeargs+=(
		-DExternalData_OBJECT_STORES="${S}/.ExternalData/MD5"
	)
	cmake-utils_src_configure
}

src_install() {
	BUILD_DIR="${WORKDIR}/${P}_build/ANTS-build"
	cmake-utils_src_install
	cd "${WORKDIR}/${P}/Scripts" || die "scripts dir not found"
	dobin *.sh
	dodir /usr/$(get_libdir)/ants
	install -t "${D}"/usr/$(get_libdir)/ants * || die
	doenvd "${FILESDIR}"/99ants
}
