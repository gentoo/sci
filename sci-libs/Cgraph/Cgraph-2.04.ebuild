# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib

DESCRIPTION="C functions that generate PostScript for publication quality scientific plots"
HOMEPAGE="http://neurovision.berkeley.edu/software/A_Cgraph.html"
SRC_URI="http://neurovision.berkeley.edu/software/${PN}${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!media-gfx/graphviz"
DEPEND=""

S="${WORKDIR}"/${PN}/source

src_prepare() {
	epatch \
		"${FILESDIR}"/Makefile.patch \
		"${FILESDIR}"/fix-src.patch
}

src_compile() {
	use amd64 && append-flags -fPIC && append-ldflags -fPIC
	emake CC=$(tc-getCC) CCFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" LIB_DIR=/usr/$(get_libdir) install
	dolib.so libcgraph.so.0.0.0
	dosym libcgraph.so.0.0.0 /usr/$(get_libdir)/libcgraph.so.0
	dosym libcgraph.so.0.0.0 /usr/$(get_libdir)/libcgraph.so

	dodoc ../docs/*
}
