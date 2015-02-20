# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Vim's rebirth for the 21st century"
HOMEPAGE="https://github.com/neovim/neovim"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/neovim/neovim.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	${RDEPEND}
	dev-lang/luajit:2
	=dev-libs/libtermkey-9999
	=dev-libs/unibilium-1.1.1
	=dev-libs/msgpack-9999
	>=dev-libs/libuv-1.1.0
	dev-lua/lpeg
	dev-lua/messagepack
"
