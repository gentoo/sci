# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-infiniband/libmthca/libmthca-1.0.5-r2.ebuild,v 1.2 2011/07/02 20:30:14 alexxy Exp $

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
