# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

MY_P=${P/_alpha/alpha}

DESCRIPTION="Finite state toolkit compatible with Xerox tools"

HOMEPAGE="http://foma.sf.net/"

SRC_URI="http://dingo.sbs.arizona.edu/~mhulden/${MY_P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE=""

DEPEND=">=sys-devel/bison-2.3
	>=sys-devel/flex-2.5.35
	sys-libs/readline
	sys-libs/libtermcap-compat"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -i -e "s/^CFLAGS =/CFLAGS = ${CFLAGS} -fPIC/" \
		-e 's/ltermcap/lcurses/' \
		-e 's/ldconfig/true/g' Makefile
}

src_compile() {
	emake || die "make failed"
	emake libfoma || die "library failed"
}

src_install() {
	dobin foma || die "installing binaries failed"
	dolib.so libfoma.so.0.9.14
	dodoc README README.symbols || die "installing docs failed"
}
