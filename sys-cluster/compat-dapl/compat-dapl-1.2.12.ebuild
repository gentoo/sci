# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

OFED_VER="1.4"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB - Direct Access Provider Library compatibility layer with 1.x"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="sys-cluster/libibverbs
		sys-cluster/librdmacm"
DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
}
