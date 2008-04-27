# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils

MY_P="Phun_beta_$(get_major_version)_$(get_after_major_version)_linux"
DESCRIPTION="Phun is a physics simulator such as gravity, friction, and so on"
HOMEPAGE="http://www.phun.at/"
SRC_URI="x86? ( http://ftp.acc.umu.se/mirror/phun/${MY_P}32.tar.bz2 )
	amd64? ( http://phun.cs.umu.se/files/${MY_P}64.tar.bz2 )"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND="virtual/opengl
	media-libs/sdl-image
	dev-libs/boost
	>=media-libs/glew-1.5"
DEPEND=""
RESTRICT="strip"

S="${WORKDIR}"

src_install() {
	insinto /opt
	doins -r Phun/
	exeinto /opt/Phun
	doexe Phun/phun.bin
	make_desktop_entry phun Phun /opt/Phun/Phun.bmp
	make_wrapper phun /opt/Phun/phun.bin /opt/Phun .
}
