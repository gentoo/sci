# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Frontend to surf to visualize algebraic curves and surfaces"
HOMEPAGE="http://imaginary2008.de/surfer.php"
SRC_URI="http://www.imaginary2008.de/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-cpp/gtkmm
	dev-util/pkgconfig"

RDEPEND="dev-cpp/gtkmm
	media-gfx/surf"

S="${WORKDIR}/${PN}-0.0.158"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# rebuild the buggy autotools
	eautoreconf
}
src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README AUTHORS
}

pkg_postinst() {
	elog "${PN} ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=210908"
}
