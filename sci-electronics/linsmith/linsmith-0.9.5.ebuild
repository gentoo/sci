# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

DESCRIPTION="linSmith is a Smith Charting program, mainly designed for educational use"
HOMEPAGE="http://jcoppens.com/soft/linsmith/index.en.php"
SRC_URI="mirror://sourceforge/linsmith/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

DEPEND=">=gnome-base/libgnomeprint-2.10.3
		>=dev-libs/libxml2-2.6.20-r2
		>=gnome-base/libgnomeui-2.10.1"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	# This patch is to prevent make install copying
	# the examples in /usr/share/linsmith
	# Now they are cp to the correct location.
	epatch ${FILESDIR}/${PN}-datafiles.patch

	einfo "Regenerating autotools files..."
	WANT_AUTOMAKE=1.8 automake || die "automake failed"
}

src_compile() {
	econf || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	# Delete this file, otherwise it is installed with the pixmaps.
	rm pixmaps/Makefile.am~

	make DESTDIR=${D} install || die "make install failed"

	insinto "/usr/share/${PN}"
	doins datafiles/conv0809

	dodoc AUTHORS NEWS README ChangeLog TODO
	doman doc/linsmith.1

	insinto "/usr/share/applications"
	doins linsmith.desktop
	insinto "/usr/share/pixmaps/${PN}"
	doins linsmith_icon.xpm

	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins doc/manual.pdf 
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins datafiles/*.circ datafiles/*.load
	fi
}
