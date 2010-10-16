# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils autotools

DESCRIPTION="Universal Non-Uniform Random number generator"
HOMEPAGE="http://statmath.wu.ac.at/unuran/"
SRC_URI="${HOMEPAGE}${P}.tar.gz"
LICENSE="GPL-2"

SLOT=0
KEYWORDS="~amd64 ~x86"
IUSE="doc examples gsl prng +rngstreams static-libs"
DEPEND="gsl? ( sci-libs/gsl )
	prng? ( sci-mathematics/prng )
	rngstreams? ( sci-mathematics/rngstreams )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-nogsl.patch
	eautoreconf
}

src_configure() {
	local udefault=builtin
	use rngstreams && udefault=rngstreams
	econf \
		--enable-shared \
		--with-urng-default=${udefault} \
		$(use_enable static-libs static) \
		$(use_with gsl urng-gsl) \
		$(use_with prng urng-prng) \
		$(use_with rngstreams urng-rngstream)
}

src_install() {
	emake DESTDIR="${D}" install ||  die "emake install failed"
	dodoc AUTHORS README NEWS KNOWN-PROBLEMS THANKS UPGRADE
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins doc/${PN}.pdf || die
	fi
	if use examples; then
		emake distclean -C examples
		rm -f examples/Makefile*
		doins -r examples
	fi
}
