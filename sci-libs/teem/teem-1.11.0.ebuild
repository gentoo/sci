# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-utils

DESCRIPTION="Scientific Raster Data Visualization Libraries"
HOMEPAGE="http://teem.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

IUSE="fftw levmar"

DEPEND="
	sys-libs/zlib
	media-libs/libpng
	app-arch/bzip2
	dev-libs/libpthread-stubs
	fftw? ( sci-libs/fftw )
	levmar? ( sci-libs/levmar )
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}-src"

src_configure(){
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
	)

	if use fftw; then
		mycmakeargs+=( -DTeem_FFTW3=ON )
	fi

	if use levmar; then
		mycmakeargs+=( -DTeem_LEVMAR=ON )
	fi

	cmake-utils_src_configure
}
