# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="NodeMon is a distributed visualization tool for monitoring system
resource utilization."
HOMEPAGE="http://nodemon.sourceforge.net/"
SRC_URI="http://downloads.sourceforge.net/nodemon/nodemon-${PV}.tar.gz"

LICENSE="NOSA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk pbs"

RDEPEND="|| ( >=dev-cpp/growler-arch-0.3.7.1 dev-cpp/growler-latest )
	gtk? ( >=x11-libs/gtkglext-1.0 >=x11-libs/gtk+-2 )"

DEPEND="${RDEPEND}"

src_compile() {
	econf \
		$(use_enable gtk) \
		$(use_with pbs) \
		|| die "could not configure"
	emake || die "make failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc README NEWS AUTHORS NOSA ChangeLog
}
