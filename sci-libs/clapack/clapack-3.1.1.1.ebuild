# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit toolchain-funcs eutils

DESCRIPTION="f2c'ed version of LAPACK"
HOMEPAGE="http://www.netlib.org/clapack/"
SRC_URI="http://gentoo.j-schmitz.net/portage/distfiles/ALL/clapack-3.1.1.1.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/libf2c-20081126"
DEPEND="${RDEPEND}"
S="${WORKDIR}"/CLAPACK-${PV}

src_unpack() {
	unpack ${P}.tgz
	cd "${S}"
	epatch "${FILESDIR}"/${PV}-Makefile.patch

	sed \
		-e "s:^CC.*$:CC = $(tc-getCC):g" \
		-e "s:^CFLAGS.*$:CFLAGS = ${CFLAGS}:g" \
		-e "s:^LOADER.*$:LOADER = $(tc-getCC):g" \
		-e "s:^LOADOPTS.*$:LOADOPTS = ${LDFLAGS}:g" \
		-e "s:^F2CLIB.*$:F2CLIB = /usr/$(get_libdir)/libf2c.a:g" \
		-e "s:LAPACKLIB.*$:LAPACKLIB = libclapack.a:g" \
	make.inc.example > make.inc

	sed \
		-e 's:"f2c.h":<f2c.h>:g' \
	-i SRC/*.c
}

src_compile() {
	emake lapacklib blaslib || die "compile failed"
}

src_install() {
	dolib.a lib${PN}.a || die
}
