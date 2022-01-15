# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="A simple medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/surf-ice"
SRC_URI="https://github.com/neurolabusc/surf-ice/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/fpc
	>=dev-lang/lazarus-1.6.2
"

src_compile() {
	# Python support will only be vaialable for the default implementation:
	# https://github.com/neurolabusc/MRIcroGL/issues/30#issuecomment-423216197
	cp -rf /etc/lazarus system-lazarus-config
	lazbuild -B --lazarusdir="/usr/share/lazarus/" --pcp="system-lazarus-config" surfice.lpi || die
}

src_install() {
	dobin surfice

	doicon -s scalable Surfice.jpg
	make_desktop_entry surfice surfice /usr/share/icons/hicolor/scalable/apps/Surfice.jpg
}
