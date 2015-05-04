# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_PROJECT="gdev"

inherit base git-2

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

PATCHES=(	"${FILESDIR}/0001-Fix-detection-of-nouveau-in-case-its-builtin.patch"
			"${FILESDIR}/0002-Fix-install-target-for-gdev-lib-userspace.patch"
			"${FILESDIR}/0003-Fix-install-target-for-gdev-lib-userspace-part2.patch"
			"${FILESDIR}/0004-Respect-extra-CFLAGS-and-LDFLAGS.patch"
			"${FILESDIR}/0005-Fix-install-target-for-cuda-lib.patch"
		)

src_configure() {
	cd cuda
	mkdir build
	cd build
	../configure
}

src_compile() {
	cd cuda/build
	emake GDEVDIR="${EPREFIX}/usr"
}

src_install() {
	cd cuda/build
	emake GDEVDIR="${EPREFIX}/usr" DESTDIR="${D}" install
}
