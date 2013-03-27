# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

WANT_AUTOCONF="2.5"
WANT_AUTOMAKE="1.10"

inherit git-2 autotools linux-mod toolchain-funcs udev

DESCRIPTION="Lustre is a parallel distributed file system"
HOMEPAGE="http://wiki.whamcloud.com/"
EGIT_REPO_URI="git://git.whamcloud.com/fs/lustre-release.git"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+client +utils server"

DEPEND="
	virtual/awk
	virtual/linux-sources
	server? (
		>=sys-kernel/spl-0.6.0_rc14-r2
		>=sys-fs/zfs-kmod-0.6.0_rc14-r4
	)
	"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/0000-LU-2982-build-make-AC-check-for-linux-arch-sandbox-f.patch"
	"${FILESDIR}/0001-LU-2800-libcfs-use-sock_alloc_file-instead-of-sock_m.patch"
	"${FILESDIR}/0002-LU-2850-compat-posix_acl_-to-from-_xattr-take-user_n.patch"
	"${FILESDIR}/0003-LU-2800-llite-introduce-local-getname.patch"
	"${FILESDIR}/0004-LU-2850-build-check-header-files-in-generated-uapi-d.patch"
	"${FILESDIR}/0005-LU-2850-kernel-3.8-upstream-removes-vmtruncate.patch"
	"${FILESDIR}/0006-LU-2850-kernel-3.8-upstream-kills-daemonize.patch"
	"${FILESDIR}/0007-LU-2987-llite-rcu-free-inode.patch"
	"${FILESDIR}/0008-LU-2850-kernel-3.9-hlist_for_each_entry-uses-3-args.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	epatch ${PATCHES[@]}
	# fix libzfs lib name we have it as libzfs.so.1
	sed -e 's:libzfs.so:libzfs.so.1:g' \
		-e 's:libnvpair.so:libnvpair.so.1:g' \
		-i lustre/utils/mount_utils_zfs.c || die

	# fix some install paths
	sed -e "s:$\(sysconfdir\)/udev:$(get_udevdir):g" \
		-e "s:$\(sysconfdir\)/sysconfig:$\(sysconfdir\)/conf.d:g" \
		-i lustre/conf/Makefile.am || die

	# replace upstream autogen.sh by our src_prepare()
	local DIRS="build libcfs lnet lustre snmp"
	local ACLOCAL_FLAGS
	for dir in $DIRS ; do
		ACLOCAL_FLAGS="$ACLOCAL_FLAGS -I $dir/autoconf"
	done
	eaclocal $ACLOCAL_FLAGS
	eautoheader
	eautomake
	eautoconf
	# now walk in configure dirs
	einfo "Reconfiguring source in libsysio"
	cd libsysio
	eaclocal
	eautomake
	eautoconf
	cd ..
	einfo "Reconfiguring source in lustre-iokit"
	cd lustre-iokit
	eaclocal
	eautomake
	eautoconf
	cd ..
	einfo "Reconfiguring source in ldiskfs"
	cd ldiskfs
	eaclocal -I config
	eautoheader
	eautomake -W no-portability
	eautoconf
	cd ..
}

src_configure() {
	econf \
		--without-ldiskfs \
		--disable-ldiskfs-build \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release="${KV_FULL}" \
		--with-zfs="${EPREFIX}/usr/src/zfs" \
		--with-spl="${EPREFIX}/usr/src/spl" \
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
