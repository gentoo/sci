# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-utils fortran-2

DESCRIPTION="Assist the transition from PGPlot to PLplot in Fortran programs"
HOMEPAGE="http://pg2plplot.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X png postscript static-libs"

DEPEND="sci-libs/plplot[fortran]"

# If USE="png" or "postscript", ensure PLplot has USE="cairo":
RDEPEND="${DEPEND}
	 sci-libs/plplot[fortran,X?]
	 png? ( sci-libs/plplot[cairo] )
	 postscript? ( sci-libs/plplot[cairo] )"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use static-libs CREATE_STATICLIB)
	)
	cmake-utils_src_configure
}

DOCS="CHANGELOG README VERSION"
