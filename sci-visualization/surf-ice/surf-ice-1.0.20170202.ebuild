# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="A simple medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/surf-ice"
SRC_URI="https://github.com/neurolabusc/surf-ice/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="dev-lang/fpc
	>=dev-lang/lazarus-1.6.2"

#S="${WORKDIR}/surf-ice-${PV}"

src_compile() {
	lazbuild -B --lazarusdir="/usr/share/lazarus/" surfice.lpi || die
}

src_install() {
	dobin surfice

	insinto /usr/bin/shaders
	doins shaders/*.txt

	insinto /usr/bin/shadersOld
	doins shadersOld/*.txt

	doicon -s scalable Surfice.jpg
	make_desktop_entry surfice surfice /usr/share/icons/hicolor/scalable/apps/Surfice.jpg
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
