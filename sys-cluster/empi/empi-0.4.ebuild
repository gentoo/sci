# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="empi"
HOMEPAGE="http://dev.gentoo.org/~jsbronder"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RDEPEND="app-admin/eselect-mpi"

src_unpack() {
	mkdir -p "${S}"
	cp "${FILESDIR}"/empi "${S}"
}

src_install() {
	dobin ${PN}
	dodoc "${FILESDIR}"/README.txt
}
