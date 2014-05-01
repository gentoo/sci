# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools-utils

MY_P="lib${P}"

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="mirror://sage/spkg/standard/${MY_P}.spkg -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug openmp static-libs"

RESTRICT="mirror"

DEPEND="openmp? ( >=sys-devel/gcc-4.2[openmp] )"
RDEPEND=""

S="${WORKDIR}/${MY_P}/src"

DOCS=( AUTHORS README )

src_configure() {
	# cachetune option is not available, because it kills (at least my) X when I
	# switch from yakuake to desktop
	myeconfargs=(
		$(use_with openmp)
		$(use_enable debug)
	)

	autotools-utils_src_configure
}
