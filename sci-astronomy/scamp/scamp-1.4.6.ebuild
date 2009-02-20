# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="Computes astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://terapix.iap.fr/soft/scamp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc threads plplot"

RDEPEND="sci-astronomy/cdsclient
	virtual/cblas
	>=sci-libs/lapack-atlas-3.8.0
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# gentoo uses cblas instead of ptcblas
	sed -i \
		-e 's/ptcblas/cblas/g' \
		acx_atlas.m4 || die "sed acx_atlas.m4 failed"
	# use pkgconfig instead of obsolete plplot-config
	epatch "${FILESDIR}"/${P}-plplot.patch
	eautoreconf
}

src_configure() {
	#local myatlas="-L/usr/$(get_libdir)/blas/atlas"
	#if use threads && \
	#	[ -f /usr/$(get_libdir)/blas/threaded-atlas/libcblas.a ]; then
	#	myatlas="-L/usr/$(get_libdir)/blas/threaded-atlas"
	#fi
	econf \
		--with-atlas="/usr/$(get_libdir)/lapack/atlas" \
		$(use_with plplot) \
		$(use_enable threads)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS BUGS
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/*.pdf || die "pdf doc install failed"
	fi
}

pkg_postinst() {
	elog "${CATEGORY}/${PN} is in development / testing phase."
	elog "Report bugs or improvements at:"
	elog "http://bugs.gentoo.org/"
}
