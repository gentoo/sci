# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="a program that will automatically determine values of the anomalous scattering factors"
HOMEPAGE="http://www.gwyndafevans.co.uk/id2.html"
SRC_URI="ftp://ftp.ccp4.ac.uk/${PN}/${PV}/packed/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RDEPEND="sci-libs/gsl
	sci-libs/Cgraph
	virtual/blas
	virtual/cblas
	sci-libs/pgplot"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}/${P}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.am.patch
	epatch "${FILESDIR}"/${PV}-aclocal.patch
	AT_M4DIR="${S}" eautoreconf
}

src_configure() {
	econf \
		--with-pgplot-prefix="/usr" \
		--with-cgraph-prefix="/usr" \
		--with-gsl-prefix="/usr" \
		--disable-gsltest || \
		die
}

src_compile() {
	emake \
		all || die
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed"
	dodoc doc/${PN}.pdf || die "nothing to read"

	if	use examples; then
		insinto /usr/share/${PN}
		doins -r examples
	fi
}
