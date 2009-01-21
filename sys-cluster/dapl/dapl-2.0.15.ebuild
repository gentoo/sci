# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

OFED_VER="1.4"
OFED_SUFFIX="-1"

inherit openib

KEYWORDS="~x86 ~amd64"

DESCRIPTION="OpenIB - Direct Access Provider Library"

IUSE=""

RDEPEND="sys-cluster/libibverbs
		sys-cluster/librdmacm"
DEPEND="${RDEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS
	doman man/*
	insinto /etc
	newins "${FILESDIR}/dat.conf.${PV}" dat.conf
}

