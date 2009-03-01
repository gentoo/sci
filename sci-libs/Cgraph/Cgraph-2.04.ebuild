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
RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/as-needed.patch
	epatch "${FILESDIR}"/Makefile.patch
}

src_compile() {
	use amd64 && append-flags -fPIC && append-ldflags -fPIC
	cd source
	emake \
		CC=$(tc-getCC) \
		CCFLAGS="${CFLAGS}" || \
	die "compilation failed"
}

src_install() {
	dodoc docs/*
	cd source
	emake \
		DESTDIR="${D}" \
		LIB_DIR=/usr/$(get_libdir) \
	install || die "install failed"
}
