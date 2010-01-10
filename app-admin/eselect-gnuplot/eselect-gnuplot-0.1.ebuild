# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-vi/eselect-vi-1.1.6.ebuild,v 1.1 2008/10/06 13:59:02 hawking Exp $

DESCRIPTION="Manages the /usr/bin/gnuplot symlink"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.8"

src_install() {
	insinto /usr/share/eselect/modules
	newins "${FILESDIR}/gnuplot.eselect-${PVR}" gnuplot.eselect || die
}
