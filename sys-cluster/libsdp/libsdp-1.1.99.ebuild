# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4"
OFED_SUFFIX="1.ofed1.4"

inherit openib

DESCRIPTION="OpenIB library that enables Socket Direct Protocol for unmodified applications"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README ChangeLog
}

