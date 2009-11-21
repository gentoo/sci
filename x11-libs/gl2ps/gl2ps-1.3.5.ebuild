# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gl2ps/gl2ps-1.3.3.ebuild,v 1.1 2009/04/07 18:41:50 bicatali Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="OpenGL to PostScript printing library"
HOMEPAGE="http://www.geuz.org/gl2ps/"
SRC_URI="http://geuz.org/${PN}/src/${P}.tgz"
LICENSE="LGPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="virtual/glut"
DEPEND="${RDEPEND}"

src_compile() {
	$(tc-getCC) ${CFLAGS} -fPIC -c gl2ps.c -o gl2ps.o \
		|| die "compiling gl2ps failed"
	$(tc-getCC) -shared ${LDFLAGS} -Wl,-soname,libgl2ps.so.1 \
		gl2ps.o -o libgl2ps.so.1 -lm -lGL -lGLU -lglut \
		|| die "linking libgl2ps failed"
}

src_install () {
	dolib.so libgl2ps.so.1 || die
	dosym libgl2ps.so.1 /usr/$(get_libdir)/libgl2ps.so
	insinto /usr/include
	doins gl2ps.h || die
	dodoc TODO
	insinto /usr/share/doc/${PF}
	if use doc; then
		doins gl2psTest* *.pdf || die
	fi
}
