# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

LICENSE="|| ( GPL-2 BSD-2 )"
SLOT="0"

KEYWORDS="~amd64"

DESCRIPTION="Meta package OpenIB"
HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI=""

IUSE="ipath opensm dapl"

DEPEND="=sys-cluster/libibverbs-${PV}
		=sys-cluster/openib-files-${PV}
		=sys-cluster/libsdp-${PV}
		=sys-cluster/libmthca-${PV}
		ipath? ( =sys-cluster/libipathverbs-${PV} )
		opensm? ( =sys-cluster/openib-osm-${PV} \
				  =sys-cluster/openib-diags-${PV} )
		=sys-cluster/openib-perf-${PV}
		dapl? ( =sys-cluster/dapl-${PV} )"
RDEPEND="${DEPEND}"

