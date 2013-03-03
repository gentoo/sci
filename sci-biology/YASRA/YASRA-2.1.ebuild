# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Yet Another Short Read Assembler aligning to a reference using LASTZ"
HOMEPAGE="http://www.bx.psu.edu/miller_lab/"
SRC_URI="http://www.bx.psu.edu/miller_lab/dist/YASRA-"${PV}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/lastz"

S="${WORKDIR}"/YASRA

src_install(){
	emake install DESTDIR="$D"
}
