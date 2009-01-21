# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4"
OFED_SUFF=""

inherit openib

KEYWORDS="~x86 ~amd64"

DESCRIPTION="A library allowing programs to use InfiniBand 'verbs' for direct access to IB hardware"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	!sys-cluster/openib-userspace"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
	docinto examples
	dodoc examples/*.[ch]
}

