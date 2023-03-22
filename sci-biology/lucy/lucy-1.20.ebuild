# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="DNA sequence quality and vector trimming tool"
HOMEPAGE="https://lucy.sourceforge.net/"
SRC_URI="https://sourceforge.net/projects/lucy/files/lucy/lucy%201.20/lucy${PV}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/lucy-${PV}p"

src_prepare(){
	default
	sed -i 's/^CC = cc/#CC = cc/' Makefile || die
	sed -i 's/^CFLAGS = -O/#CFLAGS = -O/' Makefile || die
}

src_install(){
	dobin lucy
	doman lucy.1
	dodoc README.FIRST
}
