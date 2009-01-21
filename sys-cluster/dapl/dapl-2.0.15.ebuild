# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

OFED_VER="1.4"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB - Direct Access Provider Library"
KEYWORDS="~x86 ~amd64"
IUSE="+compat"

DEPEND=">=sys-cluster/libibverbs-1.1.2
		sys-cluster/librdmacm"
RDEPEND="${DEPEND}
		compat? ( >=sys-cluster/compat-dapl-1.2.12 )"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}
