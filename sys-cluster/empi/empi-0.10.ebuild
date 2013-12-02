# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Handling Multiple MPI Implementations"
HOMEPAGE="http://dev.gentoo.org/~jsbronder/empi.xml"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE=""
DEPEND="app-admin/eselect"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	newbin "${FILESDIR}"/${P} ${PN}
	dodoc "${FILESDIR}"/README.txt
	dodoc "${FILESDIR}"/ChangeLog-${PV}

	insinto /usr/share/eselect/modules
	newins "${FILESDIR}"/eselect.mpi-${PV} mpi.eselect
	exeinto /etc/profile.d
	doexe "${FILESDIR}"/mpi.sh
	doexe "${FILESDIR}"/mpi.csh
}
