# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="MRIcroGL"
inherit desktop xdg-utils

DESCRIPTION="A simple medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/MRIcroGL"
SRC_URI="https://github.com/rordenlab/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dicom python"

BDEPEND="dev-lang/lazarus"
DEPEND="
	dev-lang/fpc
	x11-misc/appmenu-gtk-module[gtk2]
	"
RDEPEND="dicom? ( sci-biology/dcm2niix )"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	# Allegedly the Debian recipe contains some sort of Python support, wasn't able to test.
	if use python; then
		lazbuild -B \
			--lazarusdir="/usr/share/lazarus/" \
			--pcp="system-lazarus-config" \
			MRIcroGL_Debian.lpi || die
	else
		lazbuild -B \
			--lazarusdir="/usr/share/lazarus/" \
			--pcp="system-lazarus-config" \
			MRIcroGL_NoPython.lpi || die
	fi
}

src_install() {
	dobin MRIcroGL

	pushd Resources > /dev/null
		insinto /usr/share/MRIcroGL
		doins -r lut matcap Roboto.* script shader
		doicon -s scalable mricrogl.svg
		make_desktop_entry MRIcroGL MRIcroGL /usr/share/icons/hicolor/scalable/apps/mricrogl.svg
	popd
}

pkg_postinst(){
	xdg_icon_cache_update

	ewarn "This package might exhibit nondeterministic lag at startup manifesting as a blank"
	ewarn "window, which can either be closed (e.g. Alt+F4) manually leading to the actual"
	ewarn "interface being launched, or will close itself after 10-20s and start the proper GUI"
	ewarn "For more details on this look up: https://github.com/rordenlab/MRIcroGL/issues/49"
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
