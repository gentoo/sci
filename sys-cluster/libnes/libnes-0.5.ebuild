# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4"
OFED_SUFFIX="1.ofed1.4"

inherit openib

DESCRIPTION="NetEffect RNIC Userspace Library"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=sys-cluster/libibverbs-1.1.2"
RDEPEND="${DEPEND}
	!sys-cluster/openib-userspace"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
}

