# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools

DESCRIPTION="C implementation of the Double Description Method of Motzkin et al. "
HOMEPAGE="http://www.ifor.math.ethz.ch/~fukuda/cdd_home/"
SRC_URI="ftp://ftp.ifor.math.ethz.ch/pub/fukuda/cdd/${P}.tar.gz"

RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-libs/gmp-4.2.2"
RDEPEND="${DEPEND}"

src_unpack(){
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-libtool.patch"
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	dodoc README
}

pkg_postinst() {
	elog "the cddlib ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=230423"
}
