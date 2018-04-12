# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tools for bioinformatics (Tallymer, Readjoiner, gff3validator, ...)"
HOMEPAGE="http://genometools.org"
SRC_URI="http://genometools.org/pub/${P}.tar.gz"

LICENSE="ICS"
SLOT="0"
KEYWORDS=""
IUSE="cairo"

DEPEND="
	dev-libs/glib
	x11-libs/pango
	cairo? ( x11-libs/cairo )
	sci-biology/samtools:0.1-legacy
	dev-db/sqlite:3
	>=dev-lang/lua-5.1:=
	dev-lua/lpeg
	dev-lua/luafilesystem
	dev-libs/tre"
# http://keplerproject.github.io/md5/
# http://keplerproject.org/cgilua
RDEPEND="${DEPEND}"

src_prepare(){
	sed -e "s#/usr/local#"${EPREFIX}"/usr#g" -i Makefile || die
	sed -e "s#/usr/include/bam#${EPREFIX}/usr/include/bam-0.1-legacy#" -i Makefile || die
	sed -e "s#-lbam#-lbam-0.1-legacy#" -i Makefile || die
	eapply_user
}

src_compile(){
	local myemakeargs=( useshared=yes )
	! use cairo && myemakeargs+=( cairo=no )
	use x86 && myemakeargs+=( 32bit=yes )
	use amd64 && myemakeargs+=( 64bit=yes )
	emake ${myemakeargs}
}
