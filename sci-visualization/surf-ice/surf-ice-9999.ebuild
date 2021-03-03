# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 desktop xdg

DESCRIPTION="A surface rendering tool supporting neuroimaging data"
HOMEPAGE="https://github.com/neurolabusc/surf-ice"
EGIT_REPO_URI="https://github.com/neurolabusc/surf-ice.git"

LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-lang/fpc
	>=dev-lang/lazarus-1.6.2[python(-)]
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
