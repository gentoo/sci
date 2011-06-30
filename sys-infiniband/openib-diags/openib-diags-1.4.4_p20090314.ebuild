# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

OFED_VER="1.4.1"
OFED_SUFFIX="1.ofed1.4.1"

inherit openib

DESCRIPTION="OpenIB diagnostic programs and scripts needed to diagnose an IB subnet"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	>=sys-infiniband/libibcommon-1.1.2_p20090314
	>=sys-infiniband/libibumad-1.2.3_p20090314
	>=sys-infiniband/libibmad-1.2.3_p20090314
	>=sys-infiniband/openib-osm-3.2.5_p20090314"
RDEPEND="${DEPEND}"
