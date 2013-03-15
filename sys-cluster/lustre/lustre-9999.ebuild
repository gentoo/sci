# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit git-2 autotools linux-mod linux-info toolchain-funcs

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"
EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="client utils server"

DEPEND=""
RDEPEND="${DEPEND}"

BUILD_PARAMS="-C ${KV_DIR} SUBDIRS=${S}"

PATCHES=(
	"${FILESDIR}/0001-LU-2850-build-check-header-files-in-generated-uapi-d.patch"
	"${FILESDIR}/0002-LU-2850-kernel-3.7-kernel-posix-acl-needs-userns.patch"
	"${FILESDIR}/0003-LU-2850-kernel-3.7-uneports-sock_map_fd.patch"
	"${FILESDIR}/0004-LU-2850-kernel-3.7-get-putname-uses-struct-filename.patch"
	"${FILESDIR}/0005-LU-2850-kernel-3.8-upstream-removes-vmtruncate.patch"
	"${FILESDIR}/0006-LU-2850-kernel-3.8-upstream-kills-daemonize.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
	linux-info_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	epatch ${PATCHES[@]}
	# fix libzfs lib name we have it as libzfs.so.1
	sed -e 's:libzfs.so:libzfs.so.1:g' \
		-e 's:libnvpair.so:libnvpair.so.1:g' \
		-i lustre/utils/mount_utils_zfs.c || die
	sh ./autogen.sh
}

src_configure() {
	econf \
		--without-ldiskfs \
		--disable-ldiskfs-build \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release="${KV_FULL}" \
		--with-zfs="${EPREFIX}/usr/src/zfs/${KV_FULL}" \
		--with-spl="${EPREFIX}/usr/src/spl/${KV_FULL}" \
		$(use_enable client) \
		$(use_enable utils) \
		$(use_enable server)
}

src_compile() {
	default
}

src_install() {
	default
}
