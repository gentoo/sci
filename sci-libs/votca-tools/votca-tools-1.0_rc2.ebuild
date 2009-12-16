# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"
SRC_URI="http://votca.googlecode.com/files/${PF}.tar.gz
	http://www.votca.org/downloads/${PF}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="sci-libs/fftw:3.0
	dev-libs/libxml2
	sci-libs/gsl
	>=dev-libs/boost-1.33.1"

RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf || die "eautoreconf failed"
}

src_configure() {
	econf || die "econf failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc NOTICE
}
