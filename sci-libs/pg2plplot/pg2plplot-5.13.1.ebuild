# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake fortran-2

DESCRIPTION="Assist the transition from PGPlot to PLplot in Fortran programs"
HOMEPAGE="http://pg2plplot.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X png postscript static-libs"

DEPEND="
	virtual/fortran
	sci-libs/plplot[fortran]
"

# If USE="png" or "postscript", ensure PLplot has USE="cairo":
RDEPEND="${DEPEND}
	sci-libs/plplot[fortran,X?]
	png? ( sci-libs/plplot[cairo] )
	postscript? ( sci-libs/plplot[cairo] )
"

src_configure() {
	local mycmakeargs=(
		-DCREATE_STATICLIB="$(usex static-libs)"
	)
	cmake_src_configure
}
