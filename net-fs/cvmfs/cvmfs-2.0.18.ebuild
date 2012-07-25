# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils autotools toolchain-funcs linux-mod

DESCRIPTION="HTTP read-only file system for distributing software"
HOMEPAGE="http://cernvm.cern.ch/portal/filesystem"
SRC_URI="https://ecsft.cern.ch/dist/${PN}/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE="+client doc openmp server"

CDEPEND="dev-db/sqlite:3
	dev-libs/openssl
	sys-libs/zlib
	client? (
		dev-libs/jemalloc
		net-misc/curl
		sys-fs/fuse )
	server? ( >=sys-fs/redirfs-0.11 )"

RDEPEND="${CDEPEND}
	client? ( net-fs/autofs )"

DEPEND="${CDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

# needs to be either client or server
REQUIRED_USE="!server? ( client )"

pkg_setup() {
	if use server && use openmp && [[ $(tc-getCC) == *gcc* ]] && ! tc-has-openmp
	then
		ewarn "You are using a gcc without OpenMP capabilities"
		die "Need an OpenMP capable compiler"
	fi
	if use server; then
		MODULE_NAMES="cvmfsflt(misc:${S}/kernel/cvmfsflt/src)"
		BUILD_PARAMS="-C ${KERNEL_DIR} M=${S}/kernel/cvmfsflt/src"
		BUILD_TARGETS="cvmfsflt.ko"
		linux-mod_pkg_setup
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-autotools.patch \
		"${FILESDIR}"/${P}-no-redhat-init.patch \
		"${FILESDIR}"/${P}-system-redirfs.patch \
		"${FILESDIR}"/${P}-spinlock.patch \
		"${FILESDIR}"/${P}-openrc.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-sqlite3-builtin \
		--disable-libcurl-builtin \
		--disable-zlib-builtin \
		--disable-jemalloc-builtin \
		$(use_enable client cvmfs) \
		$(use_enable client mount-scripts) \
		$(use_enable openmp) \
		$(use_enable server)
}

src_compile() {
	emake
	use server && linux-mod_src_compile
	use doc && doxygen doc/cvmfs.doxy
}

src_install() {
	default
	# NEWS file is empty
	rm "${ED}"/usr/share/doc/${PF}/{INSTALL,NEWS,COPYING}

	use client && newinitd "${FILESDIR}"/${PN}.initd ${PN}
	if use server; then
		linux-mod_src_install
		newinitd "${FILESDIR}"/${PN}d.initd ${PN}d
		newconfd "${FILESDIR}"/${PN}d.confd ${PN}d
	fi
	use doc && dohtml -r doc/html/*
}

pkg_preinst() {
	use server && linux-mod_pkg_preinst
}

pkg_postinst() {
	use server && linux-mod_pkg_postinst
}

pkg_postrm() {
	use server && linux-mod_pkg_postrm
}
