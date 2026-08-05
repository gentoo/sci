# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="EOS Storage"
HOMEPAGE="https://eos-web.web.cern.ch/eos-web/"
SRC_URI="https://github.com/cern-eos/eos/archive/refs/tags/${PV}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

S=${WORKDIR}/eos-${PV}

IUSE="jemalloc rocksdb httpd"

RDEPEND="
	net-misc/curl
	sys-libs/zlib
	dev-libs/jsoncpp
	dev-libs/openssl
	net-libs/xrootd[http,kerberos]
	sys-libs/binutils-libs
	sys-libs/ncurses
	sys-apps/util-linux
	sys-fs/fuse
	sys-libs/readline
	dev-libs/leveldb
	net-libs/zeromq
	virtual/krb5
	dev-libs/libevent
	app-arch/bzip2
	dev-libs/xxhash
	net-libs/davix
	dev-libs/protobuf
	jemalloc? ( dev-libs/jemalloc )
	rocksdb? (
		dev-libs/rocksdb
		app-arch/zstd
		app-arch/lz4
	)
	httpd? ( net-libs/libmicrohttpd )
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-lang/python
	dev-cpp/sparsehash
	dev-util/pkgconf
	net-libs/cppzmq
	sys-apps/help2man
	sys-fs/xfsprogs
	dev-cpp/gtest
"

src_prepare() {
	default

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCLIENT=on
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}
