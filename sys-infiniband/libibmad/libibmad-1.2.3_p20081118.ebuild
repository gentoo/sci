# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4"
OFED_SUFFIX="1.ofed1.4"

inherit openib

DESCRIPTION="OpenIB library that provides low layer IB functions for use by the IB diagnostic and management programs."
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=sys-infiniband/libibcommon-1.1.2_p20081020
		>=sys-infiniband/libibumad-1.2.3_p20081118"
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}
