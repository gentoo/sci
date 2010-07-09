# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit cmake-utils multilib

DESCRIPTION="OpenGL to PostScript printing library"
HOMEPAGE="http://www.geuz.org/gl2ps/"
SRC_URI="http://geuz.org/${PN}/src/${P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="png zlib doc"

DEPEND="virtual/glut
	png? ( media-libs/libpng )
	zlib? ( sys-libs/zlib )
	doc? ( dev-texlive/texlive-latex
		dev-tex/tth )"

S=${WORKDIR}/${P}-source

PATCHES=( "${FILESDIR}/${P}-CMakeLists.patch" )

src_configure() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_has png PNG)
		$(cmake-utils_use_has zlib ZLIB)
		$(cmake-utils_use_has doc DOC)"
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	prepalldocs

	if [[ ${CHOST} == *-darwin* ]] ; then
		# CMake produces an invalid dylib here, but I have no clue how to fix it
		# hmm, it's also unversioned :(
		install_name_tool \
			-id "${EPREFIX}"/usr/$(get_libdir)/libgl2ps.dylib \
			"${D%/}${EPREFIX}"/usr/$(get_libdir)/libgl2ps.dylib || die
	fi
}
