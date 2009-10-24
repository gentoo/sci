# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nedit/nedit-5.5_p20090914.ebuild,v 1.1 2009/09/25 09:11:36 ulm Exp $

EAPI=2

inherit toolchain-funcs

DESCRIPTION="Multi-purpose text editor for the X Window System"
HOMEPAGE="http://nedit.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~mips ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="spell"

RDEPEND="spell? ( virtual/aspell-dict )
	x11-libs/openmotif
	x11-libs/libXp
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	|| ( dev-util/yacc sys-devel/bison )
	dev-lang/perl"

S="${WORKDIR}/${PN}"

src_configure() {
	sed -i -e "s:CFLAGS=-O:CFLAGS=${CFLAGS}:" -e "s:check_tif_rule::" \
		makefiles/Makefile.linux || die
}

src_compile() {
	emake CC="$(tc-getCC)" linux || die
	cd doc; emake doc man || die
}

src_install() {
	into /usr
	dobin source/nedit || die
	exeinto /usr/bin
	newexe source/nc neditc || die
	newman doc/nedit.man nedit.1 || die
	newman doc/nc.man neditc.1 || die

	dodoc README ReleaseNotes ChangeLog
	cd doc
	dodoc nedit.doc NEdit.ad faq.txt
	dohtml nedit.html
}
