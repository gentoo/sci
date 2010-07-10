# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools eutils

DESCRIPTION="A GTK+ graphical interactive version of nec2c."
HOMEPAGE="http://5b4az.chronos.org.uk/pages/nec2.html"
SRC_URI="http://5b4az.chronos.org.uk/pkg/nec2/xnec2c/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

S="${WORKDIR}/${PN}"

RDEPEND="dev-libs/glib
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	# fix handling of long path and filenames
	epatch "${FILESDIR}"/${P}-filename.patch

	glib-gettextize --force --copy || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS README doc/*.txt || die
	dohtml -r doc/* || die
	if use examples	; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/* || die
	fi
}
