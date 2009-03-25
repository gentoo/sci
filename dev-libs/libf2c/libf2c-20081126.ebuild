# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils

DESCRIPTION="Library that converts FORTRAN to C source."
HOMEPAGE="ftp://ftp.netlib.org/f2c/index.html"
#SRC_URI="ftp://ftp.netlib.org/f2c/${PN}.zip"
#SRC_URI="http://dev.gentoo.org/~dberkholz/distfiles/${P}.zip
#	mirror://gentoo/${P}.zip"
SRC_URI="http://gentoo.j-schmitz.net/portage/distfiles/ALL/${P}.zip"

LICENSE="libf2c"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/20051004-add-ofiles-dep.patch
	epatch "${FILESDIR}"/${PV}-link-shared-libf2c-correctly.patch
}

src_compile() {
	emake \
		-f makefile.u \
		all \
		CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)" \
		|| die "all failed"

	# Clean up files so we can recompile PIC for the shared lib
	rm *.o || die "clean failed"

	emake \
		-f makefile.u \
		libf2c.so \
		CFLAGS="${CFLAGS} -fPIC" \
		CC="$(tc-getCC)" \
		|| die "libf2c.so failed"
}

src_install () {
	dolib.a libf2c.a || die "dolib.a failed"
	dolib libf2c.so.2 || die "dolib failed"
	dosym libf2c.so.2 /usr/$(get_libdir)/libf2c.so
	insinto /usr/include
	doins f2c.h || die "f2c.h install failed"
	dodoc README Notice || die "doc install failed"
}
