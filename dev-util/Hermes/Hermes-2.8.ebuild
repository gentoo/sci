# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
inherit lua

DESCRIPTION="Lua based testing manager"
HOMEPAGE="https://github.com/TACC/Hermes"
SRC_URI="https://github.com/TACC/Hermes/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"

src_compile() {
	true
}

src_install() {
	dodir /opt/hermes
	cp -r "${S}"/* "${ED}"/opt/hermes/ || die

	doenvd "${FILESDIR}"/00hermes
}
