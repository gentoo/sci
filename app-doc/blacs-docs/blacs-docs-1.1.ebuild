# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/blas-docs/blas-docs-3.1.1.ebuild,v 1.11 2009/12/17 10:04:04 fauli Exp $

DESCRIPTION="Documentation reference for BLACS implementations"
HOMEPAGE="http://www.netlib.org/blacs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	dodoc *ps || die
}
