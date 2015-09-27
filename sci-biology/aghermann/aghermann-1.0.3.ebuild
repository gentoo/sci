# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A sleep-research experiment manager, EDF viewer & Achermann's Process S model runner"
HOMEPAGE="http://johnhommer.com/academic/code/aghermann"
SRC_URI="http://johnhommer.com/academic/code/aghermann/source/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/lua:*
	dev-libs/libconfig
	dev-libs/libunique:3
	media-libs/libsamplerate
	sci-libs/fftw:3.0
	sci-libs/gsl
	sci-libs/itpp
	x11-libs/gtk+:3
	x11-libs/vte:2.90"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf --bindir="${EPREFIX}"/bin
}
