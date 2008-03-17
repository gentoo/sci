# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="eselect-mpi"
HOMEPAGE="localhost"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="app-admin/eselect"
RDEPEND="${DEPEND}"

src_install() {
	local MODULEDIR="/usr/share/eselect/modules"
	local MODULE="mpi"
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins "${FILESDIR}"/${MODULE}.eselect-${PVR} ${MODULE}.eselect
}

