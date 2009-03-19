# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

OFED_VER="1.4"
OFED_SUFFIX="1.ofed1.4"

inherit openib

DESCRIPTION="OpenIB diagnostic programs and scripts needed to diagnose an IB subnet."
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=sys-cluster/libibcommon-1.1.2_p20081020
		>=sys-cluster/libibumad-1.2.3_p20081118
		>=sys-cluster/libibmad-1.2.3_p20081118
		>=sys-cluster/openib-osm-3.2.5_p20081207"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-remove-osmv.patch" )

src_install() {
	make DESTDIR="${D}" install || die "install failed"
}

