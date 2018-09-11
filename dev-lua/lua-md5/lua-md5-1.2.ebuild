# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Basic cryptographic facilities for Lua 5.0, 5.1 or 5.2"
HOMEPAGE="http://keplerproject.github.io/md5"
SRC_URI="https://github.com/keplerproject/md5/archive/v1.2.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/md5-"${PV}"

src_prepare(){
	epatch "${FILESDIR}"/lua-md5-1.2-respect-DESTDIR.patch
	default
}
