# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit multilib eutils flag-o-matic

DESCRIPTION="A set of C functions that generate PostScript for publication quality scientific plots"
HOMEPAGE="http://neurovision.berkeley.edu/software/A_Cgraph.html"
SRC_URI="http://neurovision.berkeley.edu/software/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/${PN}/source

src_prepare() {
	epatch "${FILESDIR}"/Makefile.patch
	epatch "${FILESDIR}"/fix-src.patch
}

src_compile() {
	use amd64 && append-flags -fPIC && append-ldflags -fPIC
	emake \
		CC=$(tc-getCC) \
		CCFLAGS="${CFLAGS}" || \
	die "compilation failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		LIB_DIR=/usr/$(get_libdir) \
		install || die "install failed"
	dolib.so libcgraph.so.0.0.0 || die
	dosym libcgraph.so.0.0.0 /usr/$(get_libdir)/libcgraph.so.0 || die
	dosym libcgraph.so.0.0.0 /usr/$(get_libdir)/libcgraph.so || die

	dodoc ../docs/*
}
