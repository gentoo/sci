# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~x86 ~amd64"

DESCRIPTION="OpenIB User MAD library functions which sit on top of the user MAD modules in the kernel.  These are used by the IB diagnostic and management tools, including OpenSM."

HOMEPAGE="http://www.openfabrics.org/"
SRC_URI="http://www.openfabrics.org/downloads/management/${P}.tar.gz"

IUSE=""

RDEPEND="sys-cluster/libibcommon"
DEPEND="${RDEPEND}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

