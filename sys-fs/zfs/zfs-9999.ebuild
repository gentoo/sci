# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.11"
AT_M4DIR=./config  # for aclocal called by eautoreconf

EGIT_REPO_URI="http://github.com/behlendorf/zfs.git"

inherit autotools eutils git-2 linux-mod

DESCRIPTION="Native ZFS for Linux"
HOMEPAGE="http://wiki.github.com/behlendorf/zfs/"
SRC_URI=""

LICENSE="CDDL GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
		>=sys-devel/spl-${PV}
		>=virtual/linux-sources-2.6
		"
RDEPEND="
		!sys-fs/zfs-fuse
		"

pkg_setup() {
	linux-mod_pkg_setup
	kernel_is gt 2 6 32 || die "Your kernel is too old. ${CATEGORY}/${PN} need 2.6.32 or newer."
	linux_config_exists || die "Your kernel sources are unconfigured."
	if linux_chkconfig_present PREEMPT; then
		eerror "${CATEGORY}/${PN} doesn't currently work with PREEMPT kernel."
		eerror "Please look at bug https://github.com/behlendorf/zfs/issues/83"
		die "PREEMPT kernel"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.0-includedir.patch
	eautoreconf
}

src_configure() {
	set_arch_to_kernel
	econf \
		--with-config=all \
		--with-linux="${KERNEL_DIR}" \
		--with-linux-obj="${KERNEL_DIR}" \
		--with-spl=/usr/include/spl \
		--with-spl-obj=/usr/include/spl/module
}

src_compile() {
	set_arch_to_kernel
	default # _not_ the one from linux-mod
}

src_install() {
	emake DESTDIR="${D}" install || die 'emake install failed'
	# Drop unwanted files
	rm -rf "${D}/usr/src" || die "removing unwanted files die"
}
