# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

DESCRIPTION="Smith charting program, mainly designed for educational use."
HOMEPAGE="http://www.jcoppens.com/soft/linsmith/index.en.php"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

RDEPEND=">=gnome-base/libgnomeprint-2.10.3
	>=dev-libs/libxml2-2.6.20-r2
	>=gnome-base/libgnomeui-2.10.1"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	# This patch is to prevent make install copying
	# the examples in /usr/share/linsmith
	# Now they are cp to the correct location.
	epatch "${FILESDIR}"/${PN}-datafiles.patch

	einfo "Regenerating autotools files..."
	eautoreconf
}

src_install() {
	# Delete this file, otherwise it is installed with the pixmaps.
	rm pixmaps/Makefile.am~

	emake DESTDIR="${D}" install || die "emake install failed"

	insinto "/usr/share/${PN}"
	doins datafiles/conv0809 || die

	dodoc AUTHORS ChangeLog NEWS NOTES README THANKS TODO || die "dodoc failed"
	doman doc/linsmith.1 || die "doman failed"

	domenu linsmith.desktop || die "domenu failed"
	doicon linsmith_icon.xpm || die "doicon failed"

	if use doc; then
		insinto "/usr/share/doc/${PF}"
		doins doc/manual.pdf || die
	fi

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		doins datafiles/*.circ datafiles/*.load || die
	fi
}
