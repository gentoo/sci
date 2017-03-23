# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils

DESCRIPTION='C++ library for geometric design and numerical simulation'
HOMEPAGE="https://gs.jku.at/gismo"
SRC_URI="https://timeraider4u.github.io/distfiles/files/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples vtk"

# Unbundling in progress,
# preparing local changes to get upstream
DEPEND="
	doc? ( >=app-doc/doxygen-1.8 )
	vtk? (  dev-qt/qtwidgets:5
		sci-mathematics/axel
			sci-mathematics/axel-vtkview
	)"

PATCHES=(
	"${FILESDIR}/${PV}/gsAxel-CMakeLists.txt.patch"
)

src_configure() {
	local mycmakeargs=(
		-DGISMO_BUILD_EXAMPLES=$(usex examples)
		-DGISMO_BUILD_AXL=$(usex vtk)
		# set to same directory as the one used by einstalldocs
		-DDOC_INSTALL_DIR="/usr/share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	if use doc ; then
		# explicitly call optional target doc
		cd "${S}_build" || die "could not find cmake build folder"
		emake doc
	fi
}
