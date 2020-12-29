# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="DNA sequence quality and vector trimming tool"
HOMEPAGE="http://lucy.sourceforge.net/" # no https
SRC_URI="https://sourceforge.net/projects/lucy/files/lucy/lucy%201.20/lucy${PV}.tar.gz"

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
