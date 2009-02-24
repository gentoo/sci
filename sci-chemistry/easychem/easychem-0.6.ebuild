# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="Chemical structure drawing program - focused on presentation."
HOMEPAGE="http://easychem.sourceforge.net/"
SRC_URI="mirror://sourceforge/easychem/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4.1
	virtual/ghostscript
	media-gfx/pstoedit"

DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-prestrip.patch" || die "Failed to apply ${P}-prestrip.patch"
}

src_compile() {
	ln -s Makefile.linux Makefile
	DGS_PATH=/usr/bin DPSTOEDIT_PATH=/usr/bin \
		C_FLAGS="${CFLAGS}" emake -e || die
}

src_install () {
	dobin easychem
	dodoc TODO
}
