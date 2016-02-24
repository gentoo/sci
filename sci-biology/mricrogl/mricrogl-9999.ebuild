# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit git-r3

DESCRIPTION="A simle medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/MRIcroGL"
SRC_URI=""
EGIT_REPO_URI="https://github.com/neurolabusc/MRIcroGL.git"

LICENSE="BSD"
SLOT="0"

RDEPEND=""
DEPEND="dev-lang/fpc
	dev-lang/lazarus"

src_compile() {
	lazbuild -B --lazarusdir="/usr/share/lazarus/" simplelaz.lpi || die
}

src_install() {
	dobin MRIcroGL

	insinto /usr/bin/shaders
	doins shaders/*.txt

	doicon mricrogl.ico
	make_desktop_entry MRIcroGL MRIcroGL mricrogl
$
}

pkg_postinst() {
	gnome2_icon_cache_update
}
pkg_postrm() {
	gnome2_icon_cache_update
}
