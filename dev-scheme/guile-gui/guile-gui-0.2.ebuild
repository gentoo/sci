# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-scheme/guile-gui/guile-gui-0.2.ebuild,v 1.4 2009/03/07 05:45:52 darkside Exp $

DESCRIPTION="Guile Scheme code that aims to implement a graphical user interface"
HOMEPAGE="http://www.ossau.uklinux.net/guile/"
SRC_URI="http://www.ossau.uklinux.net/guile/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86 ~amd64"
IUSE=""
RDEPEND="dev-scheme/guile
	x11-libs/guile-gtk"
DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc ${S}/README
}
