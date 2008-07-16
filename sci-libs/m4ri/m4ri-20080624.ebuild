# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Method of four russian for inversion (M4RI)"
HOMEPAGE="http://m4ri.sagemath.org/"
SRC_URI="http://m4ri.sagemath.org/downloads/${P}.tar.gz"

#### Remove the following line when moving this ebuild to the main tree!
RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc README
}

pkg_postinst() {
	elog "The gdmodule ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=230431"
}