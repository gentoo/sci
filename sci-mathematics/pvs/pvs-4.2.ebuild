# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit eutils

DESCRIPTION="PVS is a verification system written in Common Lisp"
HOMEPAGE="http://pvs.csl.sri.com/"
SRC_URI="http://pvs.csl.sri.com/download-open/${P}-source.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""

RDEPEND="dev-lisp/cmucl
	|| ( app-editors/emacs app-editors/xemacs )"

DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}/pvs-4.2-patch-make"
}

src_compile() {
	econf || die "econf failed"
	CMULISP_HOME="/usr" emake || die "emake failed"
	bin/relocate && ./pvsio test
}

src_install() {
	rm -R bin/relocate emacs/emacs19
	mkdir tex
	mv pvs-tex.sub pvs.sty tex/
	mv Examples examples
	mkdir -p "${D}"/usr/share/pvs
	mv bin emacs examples lib tex wish "${D}"/usr/share/pvs/
	sed -i -e "s,^PVSPATH=.*$,PVSPATH=/usr/share/pvs," pvs
	sed -i -e "s,^PVSPATH=.*$,PVSPATH=/usr/share/pvs," pvsio
	cp pvs pvsio "${D}"/usr/share/pvs/
	dobin pvs pvsio
	dodoc INSTALL LICENSE NOTICES README	
}

