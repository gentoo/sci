# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils

DESCRIPTION="2D multiple-robot simulator"
HOMEPAGE="http://playerstage.sourceforge.net/index.php?src=stage"
SRC_URI="mirror://sourceforge/playerstage/stage-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc"

RDEPEND="
	x11-libs/gtk+:2
	>=sci-electronics/player-2.0.2
	x11-apps/rgb"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-docdst-fix.patch
	sed -i \
		-e 's;/usr/X11R6/lib/X11/rgb.txt;/usr/share/X11/rgb.txt;' \
		configure.ac || die "sed failed"
	eautoreconf
}

src_configure() {
	#Disable gnome-canvas since its experimental
	econf --disable-gnomecanvas
}

src_compile() {
	default

	if use doc; then
		pushd docsrc
		doxygen -u stage.dox || die "doxygen failed"
		touch header.html || die
		emake "doc"
		popd
	fi
}

src_install() {
	default

	if use doc; then
		pushd docsrc
		emake DESTDIR="${D}" "doc-install"
		popd
	fi

	dodoc AUTHORS ChangeLog NEWS README
}
