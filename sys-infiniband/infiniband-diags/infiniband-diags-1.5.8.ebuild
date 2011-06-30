# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

OFED_VER="1.5.3.1"
OFED_SUFFIX="1"

inherit openib

DESCRIPTION="OpenIB diagnostic programs and scripts needed to diagnose an IB subnet"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="
	>=sys-infiniband/libibumad-1.3.7
	>=sys-infiniband/libibmad-1.3.7
	>=sys-infiniband/opensm-3.3.9"
RDEPEND="${DEPEND}"
