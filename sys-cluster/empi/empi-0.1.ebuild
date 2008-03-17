# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="empi"
HOMEPAGE="http://dev.gentoo.org/~jsbronder"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
RDEPEND="app-admin/eselect-mpi"

src_install() {
	dobin "${FILESDIR}"/empi
	dodoc "${FILESDIR}"/README.txt
}

