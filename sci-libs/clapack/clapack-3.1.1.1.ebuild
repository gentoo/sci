# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit toolchain-funcs eutils

DESCRIPTION="f2c'ed version of LAPACK"
HOMEPAGE="http://www.netlib.org/clapack/"
SRC_URI="http://gentoo.j-schmitz.net/portage/distfiles/ALL/clapack-3.1.1.1.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/blas"
DEPEND="${RDEPEND}"
S="${WORKDIR}"/CLAPACK-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-Makefile.patch

	sed \
		-e "s:^CC.*$:CC = $(tc-getCC):g" \
		-e "s:^CFLAGS.*$:CFLAGS = ${CFLAGS}:g" \
		-e "s:^LOADER.*$:LOADER = $(tc-getCC):g" \
		-e "s:^LOADOPTS.*$:LOADOPTS = ${LDFLAGS}:g" \
		-e "s:^BLASLIB.*$:BLASLIB = /usr/$(get_libdir)/libblas.a $(pkg-config --libs blas):g" \
		-e "s:^F2CLIB.*$:F2CLIB = /usr/$(get_libdir)/libf2c.a:g" \
	make.inc.example > make.inc
}

src_compile() {
	emake lapacklib || die "compile failed"
}

src_install() {
	newlib.a lapack_LINUX.a libclapack.a
}
