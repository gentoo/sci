# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A self contained Lua MessagePack C implementation"
HOMEPAGE="https://github.com/antirez/lua-cmsgpack"

MY_PN="lua_${PN}"

LICENSE="BSD-2"
SLOT="0"
IUSE="test"

RDEPEND=">=dev-lang/lua-5.1"
DEPEND="${RDEPEND}
	dev-libs/msgpack"

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/antirez/lua-cmsgpack.git"
	inherit git-r3
	KEYWORDS=""
	DOCS=( README.md )
else
	SRC_URI="https://github.com/antirez/lua-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	inherit vcs-snapshot
	KEYWORDS="~amd64"
	DOCS=( README )

fi

src_compile() {
	$(tc-getCC) -fPIC ${CFLAGS} -c -o ${MY_PN}.o ${MY_PN}.c || die
	$(tc-getCC) ${LDFLAGS} -shared -o ${PN}.so ${MY_PN}.o || die
}

src_test() {
	lua test.lua || die
}

src_install() {
	default
	insinto $($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)
	doins ${PN}.so
}
