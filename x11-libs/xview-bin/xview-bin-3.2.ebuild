## Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/x11-libs/xview/Attic/xview-3.2-r6.ebuild,v 1.6 2008/12/21 09:03:33 ssuominen dead $

EAPI=4

DESCRIPTION="The X Window-System-based Visual/Integrated Environment for Workstations - binary package"
HOMEPAGE="http://physionet.caregroup.harvard.edu/physiotools/xview/"
SRC_URI="mirror://debian/pool/main/x/xview/xviewg_3.2p1.4-25_i386.deb"

LICENSE="XVIEW"
SLOT="0"
KEYWORDS="-*"
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
