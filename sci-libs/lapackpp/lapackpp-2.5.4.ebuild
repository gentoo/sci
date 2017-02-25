# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="C++ wrapper for LAPACK libraries"
HOMEPAGE="http://lapackpp.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="
	virtual/blas
	virtual/lapack"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[latex] )"

src_prepare() {
	# Parallel build issues
	sed -i 's/\bmake\b/$(MAKE)/' Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--disable-atlas \
		--with-blas="$($(tc-getPKG_CONFIG) --libs blas)" \
		--with-lapack="$($(tc-getPKG_CONFIG) --libs lapack)"
}

src_compile() {
	default
	use doc && emake srcdoc
}

src_install() {
	default
	use doc && dohtml -r api-doc/html/*
}
