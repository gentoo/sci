# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool to generate command line parsers for C++ (aka Gengetopt)"
HOMEPAGE="https://github.com/gmarcais/yaggo"
SRC_URI="https://github.com/gmarcais/yaggo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e 's#/usr/local#/usr#g' -i Makefile || die
	default
}

src_install(){
	emake install DESTDIR="${ED}"
}
