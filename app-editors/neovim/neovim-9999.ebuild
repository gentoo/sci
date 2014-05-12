# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/neovim/neovim.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Vim's rebirth for the 21st century"
HOMEPAGE="https://github.com/neovim/neovim"

LICENSE="vim"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-admin/eselect-vi
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	dev-lang/luajit
	>=dev-libs/libuv-0.11.19
	dev-lua/lpeg
	dev-lua/cmsgpack"
