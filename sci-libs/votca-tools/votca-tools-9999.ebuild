# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools mercurial

DESCRIPTION="Votca tools library"
HOMEPAGE="http://www.votca.org"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sci-libs/fftw:3.0
	dev-libs/libxml2
	sci-libs/gsl
	>=dev-libs/boost-1.33.1"

RDEPEND="${DEPEND}"

EHG_REPO_URI="https://tools.votca.googlecode.com/hg/"

S="${WORKDIR}/hg"

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
