# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit git-r3

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
	dev-libs/libgdev
	x11-libs/libdrm[video_cards_nouveau]
	x11-misc/envytools"
DEPEND="
	virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	cd cuda || die
	mkdir build || die
	cd build || die
	../configure || die
}

src_compile() {
	cd cuda/build || die
	emake GDEVDIR="${EPREFIX}/usr"
}

src_install() {
	cd cuda/build || die
	emake GDEVDIR="${EPREFIX}/usr" DESTDIR="${D}" install
}
