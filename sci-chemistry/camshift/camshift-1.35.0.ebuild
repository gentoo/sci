# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit autotools eutils flag-o-matic

sDESCRIPTION="Structure based prediction of protein chemical shifts"
HOMEPAGE="http://www-vendruscolo.ch.cam.ac.uk/camshift/camshift.php"
SRC_URI="http://www-vendruscolo.ch.cam.ac.uk/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="sse"

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PV}-gentoo.patch

	eautoreconf
}

src_configure(){
	econf \
		--with-lapack \
		--with-external-blas \
		$(use_enable sse mkasm)
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" || \
		die "make failed"
}

src_install() {
	dobin bin/${PN} || die

	insinto /usr/share/${PN}
	doins -r data || die
	dodoc README NEWS ChangeLog AUTHORS || die
}
