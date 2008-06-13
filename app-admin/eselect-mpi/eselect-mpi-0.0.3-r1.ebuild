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

src_unpack() {
	MODULEDIR="/usr/share/eselect/modules"
	MODULE="mpi"
	mkdir -p "${S}"
	cp "${FILESDIR}"/${MODULE}.eselect-${PV} "${S}"/
	# Thanks to Bryan Green, bug #226105
	sed -i 's:\(setenv ESELECT_MPI_IMP\)=\(.*\):\1 \2:' ${S}/${MODULE}.eselect-${PV} 
	sed -i 's:\(setenv PATH\)=\(.*\):\1\2:' ${S}/${MODULE}.eselect-${PV} 
}
	
src_install() {
	dodir ${MODULEDIR}
	insinto ${MODULEDIR}
	newins "${S}"/${MODULE}.eselect-${PV} ${MODULE}.eselect
}
