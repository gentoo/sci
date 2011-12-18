# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/amos/amos-2.0.8-r1.ebuild,v 1.1 2010/02/11 16:47:31 weaver Exp $

EAPI=4

inherit base

DESCRIPTION="Micro Read Fast Alignment Search Tool"
HOMEPAGE="http://mrfast.sourceforge.net/"
SRC_URI="mirror://sourceforge/mrfast/mrsfast/${PV}/${P}.zip"

LICENSE="BSD"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

DEPEND=""
RDEPEND=""

PATCHES=("${FILESDIR}"/${P}-*.patch)

src_prepare() {
#	base_src_prepare
	sed -i -e 's/CFLAGS =/CFLAGS +=/' -e 's/LDFLAGS =/LDFLAGS +=/' Makefile
}

src_install() {
	dobin mrsfast
}
