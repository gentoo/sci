# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Speech analysis and synthesis"
HOMEPAGE="http://www.fon.hum.uva.nl/praat/ https://github.com/praat/praat"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

DEPEND="
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libICE
	x11-libs/libXext
	x11-libs/libSM
	x11-libs/libXp
	x11-libs/motif:0="
RDEPEND="${DEPEND}"

src_prepare() {
	# TODO: following line should be updated for non-linux etc. builds
	# (Flammie does not have testing equipment)
	cp "${S}"/makefiles/makefile.defs.linux.alsa "${S}"/makefile.defs
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r test
}
