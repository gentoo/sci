# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="Computes astrometric and photometric solutions for astronomical images"
HOMEPAGE="http://terapix.iap.fr/soft/scamp"
SRC_URI="ftp://ftp.iap.fr/pub/from_users/bertin/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc threads plplot"
RESTRICT="test"

DEPEND="sci-astronomy/cdsclient
	>=sci-libs/lapack-atlas-3.8.0
	>=sci-libs/fftw-3
	sci-libs/plplot"
# plplot option buggy if removed, force it for now.

src_unpack() {
	unpack ${A}
	cd "${S}"
	# gentoo specific patch for atlas lib dir and lib names
	epatch "${FILESDIR}"/${PN}-atlas.patch

	# fix libdir if threaded
	local myatlas="/usr/$(get_libdir)/blas/atlas"
	if use threads && \
		[ -f /usr/$(get_libdir)/blas/threaded-atlas/libcblas.a ]; then
		myatlas="/usr/$(get_libdir)/blas/threaded-atlas"
	fi
	myatlas="-L${myatlas} -L/usr/$(get_libdir)/lapack/atlas"
	sed -i -e "s:ATLAS_LIBDIR:${myatlas}:" configure.ac || die "configure.ac not found"

	eautoreconf
}

src_compile() {
	econf \
		$(use_enable threads) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog HISTORY README THANKS BUGS || die
	if use doc; then
		insinto /usr/share/doc/${PF}
		doins doc/${PN}.pdf || die "pdf doc install failed"
	fi
}
