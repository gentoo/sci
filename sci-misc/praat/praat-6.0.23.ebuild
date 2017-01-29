# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Speech analysis and synthesis"
HOMEPAGE="http://www.fon.hum.uva.nl/praat/ https://github.com/praat/praat"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="GPL-2"
SLOT="0"

DEPEND="
	x11-libs/gtk+:2
	media-libs/alsa-lib
	media-sound/pulseaudio"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply_user
	# TODO: following line should be updated for non-linux etc. builds
	# (Flammie does not have testing equipment)
	cp "${S}"/makefiles/makefile.defs.linux.pulse "${S}"/makefile.defs || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r test
}
