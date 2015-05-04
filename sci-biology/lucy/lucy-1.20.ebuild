# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="DNA sequence quality and vector trimming tool"
HOMEPAGE="http://lucy.sourceforge.net/"
SRC_URI="http://sourceforge.net/projects/lucy/files/lucy/lucy%201.20/lucy1.20.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/lucy-1.20p

src_prepare(){
	sed -i 's/^CC = cc/#CC = cc/' Makefile || die
	sed -i 's/^CFLAGS = -O/#CFLAGS = -O/' Makefile || die
}

src_compile(){
	emake || die "emake failed"
}

src_install(){
	dobin lucy || die "dobin failed"
	doman lucy.1 || die "doman failed"
	dodoc README.FIRST || die "dodoc failed"
}
