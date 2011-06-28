# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

HOMEPAGE="http://www.openfabrics.org/"
DESCRIPTION="Meta package OFED"
SRC_URI=""

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"
KEYWORDS="~amd64 ~x86"
IUSE="+dapl diags ehca ipath mlx4 mthca nes +opensm"

DEPEND="
	>=sys-infiniband/libibcm-1.0.4
	>=sys-infiniband/libibcommon-1.1.2_p20081020
	>=sys-infiniband/libibmad-1.2.3_p20081118
	>=sys-infiniband/libibumad-1.2.3_p20081118
	>=sys-infiniband/openib-files-${PV}
	>=sys-infiniband/libsdp-1.1.99
	>=sys-infiniband/openib-perf-1.2
	dapl? ( >=sys-infiniband/dapl-2.0.15 )
	diags? ( >=sys-infiniband/openib-diags-1.4.4_p20081207 )
	ehca? ( >=sys-infiniband/libehca-1.2.1 )
	ipath? ( >=sys-infiniband/libipathverbs-1.1 )
	mlx4? ( >=sys-infiniband/libmlx4-1.0 )
	mthca? ( >=sys-infiniband/libmthca-1.0.5 )
	nes? ( >=sys-infiniband/libnes-0.5 )
	opensm? ( >=sys-infiniband/openib-osm-3.2.5_p20081207 )"
RDEPEND="${DEPEND}"
