# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A low-level counterpart to Lua"
HOMEPAGE="http://terralang.org/"
#cannot be unbundled easily, because needs to compiled with clang
LUAJIT="LuaJIT-2.0.3.tar.gz"
SRC_URI="
	https://github.com/zdevito/terra/archive/release-${PV//./-}.tar.gz -> ${P}.tar.gz
	http://luajit.org/download/${LUAJIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	sys-devel/clang:0=
	dev-lang/luajit:2"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${P}.tar.gz"
	mv "${PN}"-* "${S}" || die
	ln -s "${DISTDIR}/${LUAJIT}" "${S}/build" || die
}

src_install() {
	cd release || die
	dobin terra
	dolib.so libterra.so
	dodoc README.md
	cd include || die
	doheader terra.h *.t
}
