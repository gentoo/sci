# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Predict CDS using 6mers without deriving information from base composition"
HOMEPAGE="http://www.sanger.ac.uk/resources/software"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/users/rd/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/hexamer

src_prepare(){
	default
	sed -e "s#cc -g#$(tc-getCC) ${CFLAGS}#" -i Makefile || die
}

src_install(){
	dobin hexamer hextable
	dodoc README
}
