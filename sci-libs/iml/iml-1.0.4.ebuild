# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

BLAS_COMPAT_ALL=1
BLAS_USE_CBLAS=1

inherit autotools-utils blas

DESCRIPTION="Integer Matrix Library"
HOMEPAGE="http://www.cs.uwaterloo.ca/~astorjoh/iml.html"
SRC_URI="http://www.cs.uwaterloo.ca/~astorjoh/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

AUTOTOOLS_AUTORECONF=yes
AT_M4DIR="config"
DOCS=( AUTHORS ChangeLog README )
PATCHES=(
	"${FILESDIR}"/${P}-use-any-cblas-implementation.patch
)

src_configure() {
	myeconfargs=(
		--with-default="${EPREFIX}"/usr
	)
	autotools-utils_src_configure
}
