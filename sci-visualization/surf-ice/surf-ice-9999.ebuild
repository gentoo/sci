# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 gnome2-utils

DESCRIPTION="A surface rendering tool supporting neuroimaging data"
HOMEPAGE="https://github.com/neurolabusc/surf-ice"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurolabusc/surf-ice.git"

LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="dev-lang/fpc
	>=dev-lang/lazarus-1.6.2"

src_compile() {
	lazbuild -B --lazarusdir="/usr/share/lazarus/" surfice.lpi || die
}

src_install() {
	dobin surfice

	insinto /usr/share/surfice
	doins -r lut script shaders shadersOld

	doicon -s scalable Surfice.jpg
	make_desktop_entry surfice surfice /usr/share/icons/hicolor/scalable/apps/Surfice.jpg
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
