# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_alpha/alpha}

DESCRIPTION="Finite state toolkit compatible with Xerox tools"

HOMEPAGE="http://foma.sf.net/"

SRC_URI="http://dingo.sbs.arizona.edu/~mhulden/${MY_P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64"

IUSE=""

DEPEND=">=sys-devel/bison-2.3
	>=sys-devel/flex-2.5.35
	sys-libs/readline
	dev-libs/boehm-gc"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s/^CFLAGS =/CFLAGS = ${CFLAGS} /" Makefile
}

src_install() {
	dobin foma || die "installing binaries failed"
	dodoc README README.symbols || die "installing docs failed"
}
