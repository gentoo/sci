# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils

DESCRIPTION="A sleep-research experiment manager, EDF viewer & Achermann's Process S model runner"
HOMEPAGE="http://johnhommer.com/academic/code/aghermann"
SRC_URI="http://johnhommer.com/academic/code/aghermann/source/${PN}-${PV}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/gtk+:3
	 dev-libs/libconfig
	 dev-libs/libunique:3
	 sci-libs/gsl
	 sci-libs/itpp
	 sci-libs/fftw
	 dev-libs/libconfig
	 dev-libs/libxml2
	 media-libs/libsamplerate
	 x11-libs/vte
	 dev-lang/lua"

DEPEND="${RDEPEND}"

src_configure() {
        econf \
                --bindir="${EPREFIX}"/bin
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* README
}
