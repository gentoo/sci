# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

OFED_VER="1.5.3.1"
OFED_SUFFIX="1.22.g7257cd3"
OFED_SNAPSHOT="1"

inherit eutils openib

DESCRIPTION="A library allowing programs to use InfiniBand 'verbs' for direct access to IB hardware"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	!sys-infiniband/openib-userspace"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README AUTHORS ChangeLog || die
}
