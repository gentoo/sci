# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

WANT_AUTOMAKE="1.11"
AT_M4DIR=./config  # for aclocal called by eautoreconf

EGIT_REPO_URI="http://github.com/behlendorf/zfs.git"

inherit git eutils autotools linux-mod

DESCRIPTION="Native ZFS for Linux"
HOMEPAGE="http://wiki.github.com/behlendorf/zfs/"
SRC_URI=""

LICENSE="CDDL GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
		>=sys-devel/spl-${PV}
		>=virtual/linux-sources-2.6.32
		"
RDEPEND="
		!sys-fs/zfs-fuse
		"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.6.0-includedir.patch
	eautoreconf
}

src_configure() {
	set_arch_to_kernel
	econf \
		--with-prefix="${EPREFIX}" \
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
}
