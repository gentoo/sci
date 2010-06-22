# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4.1"
OFED_SUFFIX="1.ofed1.4.1"

inherit autotools eutils openib

DESCRIPTION="OpenIB userspace RDMA CM library"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="sys-infiniband/libibverbs"
RDEPEND="${DEPEND}
		!sys-infiniband/openib-userspace"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pcfile.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install ||
	dodoc README AUTHORS ChangeLog || die
}
