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
IUSE="+client +utils server liblustre readline tests tcpd +urandom"

RDEPEND="
	virtual/awk
	readline? ( sys-libs/readline )
	tcpd? ( sys-apps/tcp-wrappers )
	server? (
		>=sys-kernel/spl-0.6.1
		>=sys-fs/zfs-kmod-0.6.1
		sys-fs/zfs
	)
	"
DEPEND="${RDEPEND}
	virtual/linux-sources"

PATCHES=(
	"${FILESDIR}/0001-LU-2982-build-make-AC-check-for-linux-arch-sandbox-f.patch"
	"${FILESDIR}/0002-LU-2686-kernel-Kernel-update-for-3.7.2-201.fc18.patch"
	"${FILESDIR}/0003-LU-3079-kernel-3.9-hlist_for_each_entry-uses-3-args.patch"
	"${FILESDIR}/0004-LU-3079-kernel-f_vfsmnt-replaced-by-f_path.mnt.patch"
)

pkg_setup() {
	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	epatch ${PATCHES[@]}
	# replace upstream autogen.sh by our src_prepare()
	local DIRS="libcfs lnet lustre snmp"
	local ACLOCAL_FLAGS
	for dir in $DIRS ; do
		ACLOCAL_FLAGS="$ACLOCAL_FLAGS -I $dir/autoconf"
	done
	eaclocal -I config $ACLOCAL_FLAGS
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
	local myconf
	if use server; then
		SPL_PATH=$(basename $(echo "${EROOT}usr/src/spl-"*)) \
			myconf="${myconf} --with-spl=${EROOT}usr/src/${SPL_PATH} \
							--with-spl-obj=${EROOT}usr/src/${SPL_PATH}/${KV_FULL}"
		ZFS_PATH=$(basename $(echo "${EROOT}usr/src/zfs-"*)) \
			myconf="${myconf} --with-zfs=${EROOT}usr/src/${ZFS_PATH} \
							--with-zfs-obj=${EROOT}usr/src/${ZFS_PATH}/${KV_FULL}"
	fi
	econf \
		${myconf} \
		--without-ldiskfs \
		--disable-ldiskfs-build \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-release="${KV_FULL}" \
		$(use_enable client) \
		$(use_enable utils) \
		$(use_enable server) \
		$(use_enable liblustre) \
		$(use_enable readline) \
		$(use_enable tcpd libwrap) \
		$(use_enable urandom) \
		$(use_enable tests)
}

src_compile() {
	default
}

src_install() {
	default
}
