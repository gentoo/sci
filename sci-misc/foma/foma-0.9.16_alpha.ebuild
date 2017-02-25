# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P=${P/_alpha/alpha}

DESCRIPTION="Finite state toolkit compatible with Xerox tools"
HOMEPAGE="http://code.google.com/p/foma/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	sys-libs/libtermcap-compat
	sys-libs/readline:0="
DEPEND="${RDEPEND}
	>=sys-devel/bison-2.3
	>=sys-devel/flex-2.5.35"

S="${WORKDIR}/${PN}"

src_prepare() {
	sed \
		-e "s/^CFLAGS =/CFLAGS = ${CFLAGS} -fPIC/" \
		-e 's/ltermcap/lcurses/' \
		-e 's/ldconfig/true/g' \
		-i Makefile || die
}

src_compile() {
	default
	emake libfoma
}

src_install() {
	# since install target doesn't have DESTDIR
	dobin foma flookup cgflookup
	dolib.so libfoma.so.${PV/_alpha/}
	doheader foma.h fomalib.h fomalibconf.h
	dodoc README README.symbols
}
