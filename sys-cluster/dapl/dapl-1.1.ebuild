# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 CPL-1.0 )"

KEYWORDS="~amd64"

DESCRIPTION="OpenIB - Direct Access Provider Library"
HOMEPAGE="http://www.openfabrics.org/"
#SRC_URI="http://www.openfabrics.org/downloads/openib-userspace-${PV}.tgz"
SRC_URI="http://mirror.gentooscience.org/openib-userspace-${PV}.tgz"
S="${WORKDIR}/openib-userspace-${PV}/src/userspace/${PN}"

IUSE=""

DEPEND="=sys-cluster/libibverbs-${PV}
		=sys-cluster/librdmacm-${PV}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS COPYING LICENSE.txt LICENSE2.txt LICENSE3.txt
	docinto doc
	dodoc doc/*.txt doc/dat.conf doc/ibhosts
}

