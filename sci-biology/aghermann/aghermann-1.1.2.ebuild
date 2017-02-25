# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A sleep-research experiment manager, EDF viewer & Process S simulator"
HOMEPAGE="http://johnhommer.com/academic/code/aghermann"
SRC_URI="http://alfinston.dlinkddns.com/johnhommer.com/code/aghermann/source/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/lua:*
	dev-libs/libconfig
	media-libs/libsamplerate
	sci-libs/fftw:3.0
	sci-libs/gsl
	sci-libs/itpp
	x11-libs/gtk+:3
	x11-libs/vte:2.91"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --bindir="${EPREFIX}"/usr/bin
}
