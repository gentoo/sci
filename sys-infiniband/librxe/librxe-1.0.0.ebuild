# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="OpenIB userspace driver for RoCE"
HOMEPAGE="http://www.openfabrics.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
SRC_URI="http://support.systemfabricworks.com/downloads/rxe/librxe-1.0.0.tar.gz"
IUSE=""

DEPEND=">=sys-infiniband/libibverbs-1.1.4"
RDEPEND="${DEPEND}
		!sys-infiniband/openib-userspace"

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
}
