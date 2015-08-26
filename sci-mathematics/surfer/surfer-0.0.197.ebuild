# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils

DESCRIPTION="Frontend to surf to visualize algebraic curves and surfaces"
HOMEPAGE="http://imaginary2008.de/surfer.php"
SRC_URI="http://www.imaginary2008.de/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-cpp/gtkmm:2.4"
RDEPEND="
	${CDEPEND}
	media-gfx/surf"
DEPEND="
	${CDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}"/${PN}-0.1

pkg_postinst() {
	elog "${PN} ebuild is still under development."
	elog "Help us improve the ebuild in:"
	elog "http://bugs.gentoo.org/show_bug.cgi?id=210908"
}
