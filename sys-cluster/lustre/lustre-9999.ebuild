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

PATCHES=(
"${FILESDIR}/2.4/0001-LU-1337-vfs-kernel-3.1-renames-lock-manager-ops.patch"
"${FILESDIR}/2.4/0002-LU-1337-vfs-kernel-3.1-kills-inode-i_alloc_sem.patch"
"${FILESDIR}/2.4/0003-LU-1337-vfs-kernel-3.1-changes-open_to_namei_flags.patch"
"${FILESDIR}/2.4/0004-LU-1337-vfs-provides-ll_get_acl-to-i_op-get_acl.patch"
"${FILESDIR}/2.4/0005-LU-1337-block-kernel-3.2-make_request_fn-returns-voi.patch"
"${FILESDIR}/2.4/0006-LU-1337-vfs-kernel-3.2-protects-inode-i_nlink.patch"
"${FILESDIR}/2.4/0007-LU-1337-vfs-3.3-changes-super_operations-inode_opera.patch"
"${FILESDIR}/2.4/0008-LU-1337-kernel-remove-unnecessary-includings-of-syst.patch"
"${FILESDIR}/2.4/0009-LU-1337-vfs-kernel-3.4-touch_atime-switchs-to-1-argu.patch"
"${FILESDIR}/2.4/0010-LU-1337-vfs-kernel-3.4-converts-d_alloc_root-to-d_ma.patch"
"${FILESDIR}/2.4/0011-LU-1337-kernel-v3.5-defines-INVALID_UID.patch"
"${FILESDIR}/2.4/0012-LU-1337-llite-kernel-3.5-renames-end_writeback-to-cl.patch"
"${FILESDIR}/2.4/0013-LU-1337-kernel-3.5-kernel-encode_fh-passes-in-parent.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
	linux-info_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	epatch ${PATCHES[@]}
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
