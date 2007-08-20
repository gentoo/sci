# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="C++ wrapper for LAPACK"
HOMEPAGE="http://lapackpp.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="virtual/blas
	virtual/lapack"
DEPEND="${DEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"

src_compile() {
	econf \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)" \
		|| die "econf failed"
	emake || die "emake failed"
	if use doc; then
		emake srcdoc || die "emake srcdoc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS README ChangeLog AUTHORS || die "dodoc failed"
	if use doc; then
		dohtml api-doc/html || die "dohtml failed"
	fi
}
