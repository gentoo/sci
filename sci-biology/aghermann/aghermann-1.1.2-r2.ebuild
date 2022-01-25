# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )

inherit lua

DESCRIPTION="A sleep-research experiment manager, EDF viewer & Process S simulator"
HOMEPAGE="http://johnhommer.com/academic/code/aghermann"
SRC_URI="http://johnhommer.com/code/aghermann/source/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-libs/libconfig
	media-libs/libsamplerate
	sci-libs/itpp
	sci-libs/fftw:3.0
	sci-libs/gsl
	sci-libs/itpp
	x11-libs/gtk+:3
	x11-libs/vte:2.91
"

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	ITPP_LIBS="/usr/$(get_libdir)/libitpp.so" ITPP_CFLAGS="/usr/include/itpp/" econf --bindir="${EPREFIX}"/usr/bin
}
