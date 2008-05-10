# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="|| ( GPL-2 BSD-2 )"

KEYWORDS="~amd64"

DESCRIPTION="a library allowing programs to use InfiniBand 'verbs' for direct access to IB hardware"
SRC_URI="http://www.openfabrics.org/downloads/verbs/${P}.tar.gz"
HOMEPAGE="http://www.openfabrics.org/"

IUSE=""

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}
	!sys-cluster/openib-userspace"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS ChangeLog
	docinto examples
	dodoc examples/*.[ch]
}

