# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Speech analysis and synthesis"
HOMEPAGE="https://www.fon.hum.uva.nl/praat/ https://github.com/praat/praat"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

DEPEND="
	x11-libs/gtk+:2
	media-libs/alsa-lib
	media-sound/pulseaudio"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# TODO: following line should be updated for non-linux etc. builds
	# (Flammie does not have testing equipment)
	cp makefiles/makefile.defs.linux.pulse makefile.defs || die

	cat <<-EOF >> makefile.defs
		CFLAGS += ${CFLAGS}
		CXXFLAGS += ${CXXFLAGS}
	EOF
}

src_install() {
	dobin ${PN}
	insinto /usr/share/${PN}
	doins -r test
}
