# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="empi"
HOMEPAGE="http://dev.gentoo.org/~jsbronder/empi.xml"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""
DEPEND="app-admin/eselect"
RDEPEND="${DEPEND}"

src_install() {
	newbin "${FILESDIR}"/${P} ${PN} || die
	dodoc "${FILESDIR}"/README.txt || die
	dodoc "${FILESDIR}"/ChangeLog-${PV} || die

	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/eselect.mpi-${PV} mpi.eselect || die
	exeinto /etc/profile.d
	doexe "${FILESDIR}"/mpi.sh
	doexe "${FILESDIR}"/mpi.csh
}
