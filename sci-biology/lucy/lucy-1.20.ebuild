# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="DNA sequence quality and vector trimming tool"
HOMEPAGE="http://lucy.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/lucy/files/lucy/lucy%201.20/lucy1.20.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"/lucy-1.20p

src_prepare(){
	sed -i 's/^CC = cc/#CC = cc/' Makefile || die
	sed -i 's/^CFLAGS = -O/#CFLAGS = -O/' Makefile || die
}

src_install(){
	dobin lucy
	doman lucy.1
	dodoc README.FIRST
}
