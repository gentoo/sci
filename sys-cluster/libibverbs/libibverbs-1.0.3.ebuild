# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

SLOT="0"
LICENSE="GPL-2"

# NOTE: actually distributed under two licenses, of which "you choose to be
# licensed under", according to the COPYING file: "GPL-2" and "OpenIB.org BSD"

KEYWORDS="~amd64"

DESCRIPTION="a library that allows programs to use InfiniBand 'verbs' for direct access to IB hardware from userspace"
SRC_URI="http://www.openib.org/downloads/${P}.tar.gz"
HOMEPAGE="http://www.openib.org/"

IUSE=""

DEPEND="sys-fs/sysfsutils"
RDEPEND="${DEPEND}"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc README AUTHORS COPYING ChangeLog
	docinto examples
	dodoc examples/*.[ch]
}

