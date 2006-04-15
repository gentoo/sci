# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils flag-o-matic

DESCRIPTION="The VLSI design CAD tool"
HOMEPAGE="http://www.opencircuitdesign.com/magic/index.html"
SRC_URI="http://www.opencircuitdesign.com/magic/archive/${P}.tgz \
	ftp://ftp.mosis.edu/pub/sondeen/magic/new/beta/2002a.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

RDEPEND="sys-libs/ncurses
	sys-libs/readline
	dev-lang/tcl
	dev-lang/tk
	dev-tcltk/blt"
DEPEND="${RDEPEND}
	sys-apps/findutils
	dev-lang/perl
	app-shells/tcsh"


src_compile() {
	# Short-circuit top-level configure script to retain CFLAGS
	cd scripts

	./configure \
		--prefix=/usr \
		--libdir=/usr/share \
		--mandir=/usr/share/man \
		|| die "configure failed"

	cd ..
	make || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "install failed"
	dodoc README README.Tcl TODO

	# Install latest MOSIS tech files
	cp -a ${WORKDIR}/2002a ${D}/usr/share/magic/sys/current

	keepdir /var/lock/magic
	chmod +t ${D}/var/lock/magic
	chmod ugo+rwx ${D}/var/lock/magic
}

pkg_postinst() {
	ewarn 'Magic now uses "~/.magicrc" as the personal startup file rather'
	ewarn 'than "~/.magic" or the previously Gentoo specific "~/.magic-cad".'
}
