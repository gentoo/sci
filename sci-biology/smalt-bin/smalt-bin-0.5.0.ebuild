# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Pairwise sequence alignment mapping DNA reads onto genomic reference, better over SSAHA2."
HOMEPAGE="http://www.sanger.ac.uk/resources/software/smalt/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-0.5.0.tgz"

LICENSE="GRL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/smalt-"${PV}"

src_install(){
	if use x86; then
		newbin smalt_i386 smalt || die
	fi
	if use amd64; then
		newbin smalt_x86_64 smalt || die
	fi
	if use ia64; then
		newbin smalt_ia64 || die
	fi
	dodoc NEWS smalt_manual.pdf || die
	doman smalt.1 || die
}
