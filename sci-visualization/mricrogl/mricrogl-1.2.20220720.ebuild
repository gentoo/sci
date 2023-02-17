# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="MRIcroGL"
inherit desktop

DESCRIPTION="A simple medical imaging visualization tool"
HOMEPAGE="https://github.com/neurolabusc/MRIcroGL"
SRC_URI="https://github.com/rordenlab/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dicom python"

RDEPEND="dicom? ( sci-biology/dcm2niix )"
DEPEND="
	dev-lang/fpc
	dev-lang/lazarus
	"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	# Allegedly the Debian recipe contains some sort of Python support, wasn't able to test.
	if use python; then
		lazbuild -B --lazarusdir="/usr/share/lazarus/" --pcp="system-lazarus-config" MRIcroGL_Debian.lpi || die
	else
		lazbuild -B --lazarusdir="/usr/share/lazarus/" --pcp="system-lazarus-config" MRIcroGL_NoPython.lpi || die
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
