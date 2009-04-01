# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils

MY_P="Phun_beta_$(get_major_version)_$(get_after_major_version)_linux"
DESCRIPTION="Physics sandbox and simulator for gravity, friction"
HOMEPAGE="http://www.phunland.com/"
SRC_URI="x86? ( http://www.phunland.com/download/${MY_P}32.tgz )
	amd64? ( http://www.phunland.com/download/${MY_P}64.tgz )"

LICENSE="Algodoo"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror strip"

RDEPEND="virtual/opengl
	dev-libs/libzip
	media-libs/sdl-image
	amd64? ( >=sys-devel/gcc-4.2 =media-libs/glew-1.5* )
	x86? ( =media-libs/glew-1.3* )
	dev-libs/boost"

S="${WORKDIR}/Phun"
PHUN_DIR=/opt/Phun

src_prepare() {
	rm -rf LICENSE* lib || die
}

src_install() {
	insinto ${PHUN_DIR}
	doins -r * || die
	exeinto ${PHUN_DIR}
	doexe phun.bin
	make_wrapper ${PN} "./phun.bin" ${PHUN_DIR} ${PHUN_DIR}
	make_desktop_entry ${PN} "Phun Physics Sandbox"	\
		"${PHUN_DIR}/data/textures/logos/icon.bmp"
}
