# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit openib

DESCRIPTION="Meta package OFED"
SRC_URI=""
KEYWORDS="~amd64 ~x86"
IUSE="ipath +opensm +dapl mthca ehca mlx4 nes"

DEPEND=">=sys-cluster/libibcm-1.0.4
	>=sys-cluster/libibcommon-1.1.2_p20081020
	>=sys-cluster/libibmad-1.2.3_p20081118
	>=sys-cluster/libibumad-1.2.3_p20081118
	>=sys-cluster/openib-files-${PV}
	>=sys-cluster/libsdp-1.1.99
	>=sys-cluster/openib-perf-1.2
	dapl? ( >=sys-cluster/dapl-2.0.15 )
	diags? ( >=sys-cluster/openib-diags-1.4.4_p20081207 )
	ehca? ( >=sys-cluster/libehca-1.2.1 )
	ipath? ( >=sys-cluster/libipathverbs-1.1 )
	mlx4? ( >=sys-cluster/libmlx4-1.0 )
	mthca? ( >=sys-cluster/libmthca-1.0.5 )
	nes? ( >=sys-cluster/libnes-0.5 )
	opensm? ( >=sys-cluster/openib-osm-3.2.5_p20081207 )"
RDEPEND="${DEPEND}"

src_unpack() {
	einfo "Nothing to unpack"
}
