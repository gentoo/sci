# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools

DESCRIPTION="Frontend to surf to visualize algebraic curves and surfaces"
HOMEPAGE="http://imaginary2008.de/surfer.php"
SRC_URI="http://www.imaginary2008.de/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-cpp/gtkmm:2.4
	media-gfx/surf"
DEPEND="
	dev-cpp/gtkmm:2.4
	dev-util/pkgconfig"

DOCS="README AUTHORS"

S="${WORKDIR}"/${PN}-0.1

src_prepare() {
	eautoreconf
}

pkg_postinst() {
	elog "${PN} ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=210908"
}
