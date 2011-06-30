# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

OFED_VER="1.5.3.1"
OFED_SUFFIX="0.42.gf350d3d"
OFED_SNAPSHOT="1"

inherit openib

DESCRIPTION="OpenIB uverbs micro-benchmarks"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=sys-infiniband/libibverbs-1.1.4
	>=sys-infiniband/librdmacm-1.0.14"
RDEPEND="${DEPEND}"

src_install() {
	dodoc README runme
	dobin ib_*
}
