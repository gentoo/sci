# Copyright 1999-2011 Gentoo Foundation
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
	>=sys-infiniband/libibcm-1.0.5
	>=sys-infiniband/libibmad-1.3.7
	>=sys-infiniband/libibumad-1.3.7
	>=sys-infiniband/openib-files-${PV}
	>=sys-infiniband/libsdp-1.1.108
	>=sys-infiniband/perftest-1.3.0
	dapl? ( >=sys-infiniband/dapl-2.0.32 )
	diags? ( >=sys-infiniband/infiniband-diags-1.5.8 )
	ehca? ( >=sys-infiniband/libehca-1.2.2 )
	ipath? ( >=sys-infiniband/libipathverbs-1.1.4 )
	mlx4? ( >=sys-infiniband/libmlx4-1.0.1 )
	mthca? ( >=sys-infiniband/libmthca-1.0.5 )
	nes? ( >=sys-infiniband/libnes-1.1.1 )
	opensm? ( >=sys-infiniband/opensm-3.3.9 )"
RDEPEND="${DEPEND}"
