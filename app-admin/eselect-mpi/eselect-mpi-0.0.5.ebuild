# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="eselect-mpi"
HOMEPAGE="http://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-admin/eselect"
RDEPEND="${DEPEND}"

src_install() {
	MODULEDIR="/usr/share/eselect/modules"
	MODULE="mpi"
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins "${FILESDIR}"/eselect.${MODULE}-${PV} ${MODULE}.eselect
	exeinto /etc/profile.d
	doexe "${FILESDIR}"/mpi.csh
	doexe "${FILESDIR}"/mpi.sh
}
