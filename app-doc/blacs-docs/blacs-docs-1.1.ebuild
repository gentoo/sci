# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Documentation reference for BLACS implementations"
HOMEPAGE="http://www.netlib.org/blacs/"
SRC_URI="https://dev.gentoo.org/~jlec/distfiles/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	dodoc *ps
}
