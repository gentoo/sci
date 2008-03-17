# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB uverbs micro-benchmarks"

HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"
S="${WORKDIR}/openib-userspace-${PV}/src/userspace/perftest"

IUSE=""

DEPEND="=sys-cluster/libibverbs-${PV}
		 =sys-cluster/librdmacm-${PV}"

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodoc README Copying runme
	dobin ib_*
}

