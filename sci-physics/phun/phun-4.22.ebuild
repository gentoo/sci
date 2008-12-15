# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils

MY_P="Phun_beta_$(get_major_version)_$(get_after_major_version)_linux"
DESCRIPTION="Physics sandbox and simulator for gravity, friction"
HOMEPAGE="http://www.phunland.com/"
SRC_URI="x86? ( http://www.phunland.com/download/${MY_P}32.tar.bz2 )
	amd64? ( http://www.phunland.com/download/${MY_P}64.tar.bz2 )"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="virtual/opengl
	media-libs/sdl-image
	dev-libs/boost
	>=media-libs/glew-1.5"
DEPEND=""
RESTRICT="strip mirror"

S="${WORKDIR}"

src_install() {
	rm -rf Phun/lib
	insinto /opt
	doins -r Phun/ || die
	exeinto /opt/Phun
	doexe Phun/phun.bin || die
	make_desktop_entry phun "Phun physics sandbox" /opt/Phun/icon.png
	make_wrapper phun /opt/Phun/phun.bin /opt/Phun .
}
