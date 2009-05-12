# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib toolchain-funcs

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
	epatch "${FILESDIR}"/${PV}-Makefile.patch
	sed "s:GENTOO_LIBDIR:$(get_libdir):g" -i Makefile
}

src_configure() {
# configure is broken
:
}

src_compile() {
	emake -j1 \
		CC=$(tc-getCC) \
		all || die
}

src_install() {
	dobin ${PN} ${PN}-pg || die "no bins installed"
	dodoc doc/${PN}.pdf || die "nothing to read"
	doman man/${PN}.1 || die

	insinto /usr/share/${PN}
	use exmaples && doins -r examples
}
