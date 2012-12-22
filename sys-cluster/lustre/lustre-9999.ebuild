# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.9"

inherit git-2 autotools linux-mod linux-info toolchain-funcs

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"
EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="utils"

DEPEND=""
RDEPEND="${DEPEND}"

BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"

pkg_setup() {
	linux-mod_pkg_setup
	linux-info_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	apply_user_patches
	sh ./autogen.sh
}

src_configure() {
	econf \
		--enable-client \
		--disable-server \
		--without-ldiskfs \
		--disable-ldiskfs-build \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release=${KV_FULL} \
		$(use_enable utils)
}

src_compile() {
	default
}

src_install() {
	default
}
