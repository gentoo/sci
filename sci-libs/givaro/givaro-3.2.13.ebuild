# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="C++ library for arithmetic and algebraic computations"
HOMEPAGE="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/"
SRC_URI="http://ljk.imag.fr/CASYS/LOGICIELS/givaro/Downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~ppc64"
IUSE=""

RDEPEND=">=dev-libs/gmp-4.1-r1:0="
DEPEND="${RDEPEND}"

src_configure(){
	econf "--enable-shared"
}

pkg_postinst() {
	elog "The givaro ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=227803"
}
