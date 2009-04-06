# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
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
DEPEND=""
RDEPEND="virtual/opengl
	dev-libs/libzip
	media-libs/sdl-image
	=media-libs/glew-1.5*
	dev-libs/boost"

S="${WORKDIR}/Phun"
PHUN_DIR=/opt/Phun

src_prepare() {
	rm -rf LICENSE* lib phun || die
}

src_install() {
	insinto ${PHUN_DIR}
	doins -r * || die
	exeinto ${PHUN_DIR}
	doexe phun.bin
	make_wrapper ${PN} "./phun.bin" ${PHUN_DIR} ${PHUN_DIR}
	make_desktop_entry /opt/Phun/phun "Phun Physics Sandbox"	\
		"${PHUN_DIR}/data/textures/logos/icon.bmp"
}
