# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3 toolchain-funcs

DESCRIPTION="Gdev is open-source GPGPU runtime"
HOMEPAGE="https://github.com/shinpei0208/gdev"
SRC_URI=""
EGIT_REPO_URI="
	git://github.com/shinpei0208/gdev.git
	https://github.com/shinpei0208/gdev.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	x11-libs/libdrm[video_cards_nouveau]
	x11-misc/envytools"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	cd lib || die
	mkdir build || die
	cd build || die
	../configure --target=user || die
}

src_compile() {
	cd lib/build || die
	emake \
		EXTRA_CFLAGS="$($(tc-getPKG_CONFIG) --cflags-only-I libdrm)" \
		EXTRA_LIBS="$($(tc-getPKG_CONFIG) --libs libdrm_nouveau)"
}

src_install() {
	cd lib/build || die
	emake GDEVDIR="${EPREFIX}/usr" DESTDIR="${D}" install
}
