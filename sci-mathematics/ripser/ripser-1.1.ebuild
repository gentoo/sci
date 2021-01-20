# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="efficient computation of Vietoris-Rips persistence barcodes"
HOMEPAGE="https://github.com/Ripser/ripser"
SRC_URI="https://github.com/Ripser/ripser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE="debug progress sparsehash"

BDEPEND="
	sparsehash? ( dev-cpp/sparsehash )
"

PATCHES=(
	"${FILESDIR}/ripser-Makefile.patch"
)

src_compile() {
	emake USE_GOOGLE_HASHMAP=$(usex sparsehash 1 0) \
		  INDICATE_PROGRESS=$(usex progress 1 0) \
		  NDEBUG=$(usex debug 0 1)\
		  all
}

src_install() {
	emake prefix="/usr" DESTDIR="${D}" install
}
