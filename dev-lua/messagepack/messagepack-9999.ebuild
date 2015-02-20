# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs git-r3

DESCRIPTION="A pure Lua implementation of the MessagePack serialization format"
HOMEPAGE="http://fperrad.github.io/lua-MessagePack/"
EGIT_REPO_URI="https://github.com/fperrad/lua-MessagePack.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1:*"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	emake LUAVER="$($(tc-getPKG_CONFIG) --variable V lua)" \
		PREFIX="${EPREFIX}"/usr DESTDIR="${D}" install
}
