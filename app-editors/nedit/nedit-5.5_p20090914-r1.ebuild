# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Multi-purpose text editor for the X Window System"
HOMEPAGE="http://nedit.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="spell"

RDEPEND="
	spell? ( virtual/aspell-dict )
	x11-libs/libXp
	x11-libs/libXpm
	x11-libs/openmotif"
DEPEND="${RDEPEND}
	|| ( dev-util/yacc sys-devel/bison )
	dev-lang/perl"

S="${WORKDIR}/${PN}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-ldflags.patch
}

src_configure() {
	sed \
		-e "s:CFLAGS=-O:CFLAGS=${CFLAGS}:" \
		-e "s:check_tif_rule::" \
		-i makefiles/Makefile.linux || die
}

src_compile() {
	emake CC="$(tc-getCC)" linux || die
	cd doc; emake doc man || die
}

src_install() {
	dobin source/nedit || die
	newbin source/nc neditc || die
	newman doc/nedit.man nedit.1 || die
	newman doc/nc.man neditc.1 || die

	dodoc README ReleaseNotes ChangeLog \
		doc/{nedit.doc,NEdit.ad,faq.txt}
}
