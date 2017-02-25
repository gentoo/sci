# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Distributed visualization tool for monitoring system resource utilization"
HOMEPAGE="http://nodemon.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/nodemon/nodemon-${PV}.tar.gz"

LICENSE="NOSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk pbs"

RDEPEND="
	>=dev-cpp/growler-arch-0.3.7.1
	gtk? (
		>=x11-libs/gtkglext-1.0
		x11-libs/gtk+:2
	)"
DEPEND="${RDEPEND}"

DOCS="README NEWS AUTHORS NOSA ChangeLog"

src_configure() {
	econf \
		$(use_enable gtk) \
		$(use_with pbs)
}
