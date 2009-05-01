# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="Scientific multi-agent simulation library"
HOMEPAGE="http://sourceforge.net/projects/zarja/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="sci-libs/gsl
	virtual/lapack
	>=sci-libs/fftw-3
	dev-libs/boost
	dev-cpp/tclap"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	econf --includedir=/usr/include/zarja
}

src_compile() {
	emake || die "emake failed"
	if use doc; then
		doxygen Doxyfile || die "doc generation failed"
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die "emake install failed"
	dodoc README AUTHORS FAQ
	if use doc; then
		dohtml html/* || die
	fi
}
