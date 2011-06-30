# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/scamp/scamp-1.7.0.ebuild,v 1.1 2010/05/03 21:44:04 bicatali Exp $

EAPI=3
inherit eutils

DESCRIPTION="Extracts models of the Point Spread Function from FITS images"
HOMEPAGE="http://www.astromatic.net/software/psfex"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc plplot threads"

RDEPEND="virtual/cblas
	sci-libs/lapack-atlas
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# gentoo uses cblas instead of ptcblas (linked to threaded with eselect)
	sed -i \
		-e 's/ptcblas/cblas/g' \
		configure || die "sed failed"
}

src_configure() {
	econf \
		--with-atlas="${EPREFIX}/usr/$(get_libdir)/lapack/atlas" \
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
