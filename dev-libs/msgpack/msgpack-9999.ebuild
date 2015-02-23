# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/msgpack/msgpack-0.5.9.ebuild,v 1.1 2014/07/09 04:54:50 radhermit Exp $

EAPI="5"
AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib flag-o-matic git-r3

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/ https://github.com/msgpack/msgpack-c/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/${PN}/${PN}-c"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs test"

DEPEND="test? ( >=dev-cpp/gtest-1.6.0-r2[${MULTILIB_USEDEP}] )"

DOCS=( CHANGELOG.md README.md CROSSLANG.md QUICKSTART-C.md QUICKSTART-CPP.md)

src_prepare() {
	append-cflags "-I${S}/include"
	sed -i 's/-O3 //' configure.in || die
	autotools-multilib_src_prepare
}
