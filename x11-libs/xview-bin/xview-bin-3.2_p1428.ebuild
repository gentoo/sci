# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DEBVER="3.2p1.4-28.1"

DESCRIPTION="The X Window-System-based Visual/Integrated Environment - binary package"
HOMEPAGE="http://physionet.caregroup.harvard.edu/physiotools/xview/"
SRC_URI="mirror://debian/pool/main/x/xview/xviewg_${DEBVER}_i386.deb"

LICENSE="XVIEW"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

S=${WORKDIR}

QA_PREBUILT="*"

src_unpack() {
	unpack ${A}
	unpack ./data.tar.gz
}

src_install() {
	local lib_dir
	if use prefix; then
		lib_dir=lib
	else
		lib_dir=lib32
	fi
	dodir /usr/${lib_dir}/
	mv usr/lib/* "${ED}"/usr/${lib_dir}/ || die
}
