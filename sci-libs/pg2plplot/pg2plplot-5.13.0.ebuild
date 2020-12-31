# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE=Release
inherit cmake fortran-2
CMAKE_MAKEFILE_GENERATOR="emake"

DESCRIPTION="Assist the transition from PGPlot to PLplot in Fortran programs"
HOMEPAGE="http://pg2plplot.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X png postscript static-libs"

DEPEND="virtual/fortran
		sci-libs/plplot[fortran]"

# If USE="png" or "postscript", ensure PLplot has USE="cairo":
RDEPEND="${DEPEND}
		 sci-libs/plplot[fortran,X?]
		 png? ( sci-libs/plplot[cairo] )
		 postscript? ( sci-libs/plplot[cairo] )"

src_configure() {
	local mycmakeargs=(
		-DCREATE_STATICLIB="$(usex static-libs)"
	)
	cmake_src_configure
}

DOCS="CHANGELOG README VERSION"
