# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="DNA mapper for single-end reads to detect structural variants (SV)"
HOMEPAGE="https://github.com/GregoryFaust/yaha"
EGIT_REPO_URI="https://github.com/GregoryFaust/yaha.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-fpermissive.patch
	"${FILESDIR}"/${P}-buildsystem.patch
)

src_prepare() {
	default
	append-cflags '-DCOMPILE_USER_MODE' '-DBUILDNUM=$(BUILDNUM)' -std=gnu99
	append-cxxflags '-DCOMPILE_USER_MODE' '-DBUILDNUM=$(BUILDNUM)'
	tc-export CC CXX
	export CFLAGS
	export CXXFLAGS
}

src_install(){
	dobin bin/yaha
	dodoc YAHA_User_Guide.0.1.83.pdf
	dodoc README.md
}
