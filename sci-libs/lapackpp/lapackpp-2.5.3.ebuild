# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="C++ wrapper for LAPACK libraries"
HOMEPAGE="http://lapackpp.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen[latex] )"

src_prepare() {
	# Parallel build issues
	sed -i 's/\bmake\b/$(MAKE)/' Makefile.in || die
}

src_configure() {
	econf \
		--disable-atlas \
		--enable-static \
		--with-blas="$(pkg-config --libs blas)" \
		--with-lapack="$(pkg-config --libs lapack)"
}

src_compile() {
	default_src_compile
	if use doc; then
		emake srcdoc || die "emake srcdoc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc NEWS MAINTAINER RELEASE.NOTES README ChangeLog AUTHORS
	if use doc; then
		dohtml -r api-doc/html/* || die "dohtml failed"
	fi
}
