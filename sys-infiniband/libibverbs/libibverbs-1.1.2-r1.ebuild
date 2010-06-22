# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4.1"
OFED_SUFFIX="1.ofed1.4.1"

inherit autotools eutils openib

DESCRIPTION="A library allowing programs to use InfiniBand 'verbs' for direct access to IB hardware"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	!sys-infiniband/openib-userspace"

src_prepare() {
	epatch "${FILESDIR}"/${P}-pcfile.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README AUTHORS ChangeLog || die
}
