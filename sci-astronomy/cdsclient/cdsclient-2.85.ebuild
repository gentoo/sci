# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit multilib

DESCRIPTION="Collection of scripts to access the CDS databases"
HOMEPAGE="http://cdsweb.u-strasbg.fr/doc/cdsclient.html"
SRC_URI="ftp://cdsarc.u-strasbg.fr/pub/sw/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="virtual/libc"
RDEPEND="app-shells/tcsh"
RESTRICT="nostrip"
S=${WORKDIR}/${P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's/aclient.tex//' configure
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man
	dodir /usr/$(get_libdir)
	make \
		PREFIX=${D}/usr \
		MANDIR=${D}/usr/share/man \
		LIBDIR=${D}/usr/$(get_libdir) \
		install || die " make install failed"
}
