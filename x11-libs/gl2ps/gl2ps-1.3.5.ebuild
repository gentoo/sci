# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit cmake-utils eutils

DESCRIPTION="OpenGL to PostScript printing library"
HOMEPAGE="http://www.geuz.org/gl2ps/"
SRC_URI="http://geuz.org/${PN}/src/${P}.tgz"
LICENSE="LGPL-2"
SLOT="0"
IUSE="+png +zlib"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="
	virtual/glut
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${P}-source

src_prepare() {
	epatch "${FILESDIR}"/${PV}-CMakeLists.patch

	sed \
		-e "s:GENTOOLIB:$(get_libdir):g" \
		-i CMakeLists.txt
}

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_has png PNG)
		$(cmake-utils_use_has zlib ZLIB)"

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepalldocs || die
}
