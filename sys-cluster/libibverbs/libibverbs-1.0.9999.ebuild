# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

BRANCH=${PV/.9999}
ESVN_REPO_URI="https://openfabrics.org/svn/gen2/branches/${BRANCH}/src/userspace/libibverbs"
ESVN_BOOTSTRAP="autogen.sh"

SLOT="0"
LICENSE="GPL-2"

# NOTE: actually distributed under two licenses, of which "you choose to be
# licensed under", according to the COPYING file: "GPL-2" and "OpenIB.org BSD"

KEYWORDS="-*"

DESCRIPTION="OpenIB InfiniBand 'verbs' library for direct access to IB hardware from userspace"
HOMEPAGE="http://www.openib.org/"
SRC_URI=""

IUSE=""

DEPEND="virtual/libc
        sys-fs/sysfsutils"
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

