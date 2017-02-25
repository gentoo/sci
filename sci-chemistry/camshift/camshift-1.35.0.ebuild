# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils flag-o-matic

DESCRIPTION="Structure based prediction of protein chemical shifts"
HOMEPAGE="http://www-vendruscolo.ch.cam.ac.uk/camshift/camshift.php"
SRC_URI="http://www-vendruscolo.ch.cam.ac.uk/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cpu_flags_x86_sse"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-gcc47.patch
	"${FILESDIR}"/${PV}-gentoo.patch )

src_configure(){
	local myeconfargs=(
		--with-lapack
		--with-external-blas
		$(use_enable cpu_flags_x86_sse mkasm)
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin "${BUILD_DIR}"/bin/${PN}

	insinto /usr/share/${PN}
	doins -r data
	dodoc README NEWS ChangeLog AUTHORS
}
