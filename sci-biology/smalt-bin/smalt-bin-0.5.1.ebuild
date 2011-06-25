# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Pairwise sequence alignment mapping DNA reads onto genomic reference, better over SSAHA2"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/smalt/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub4/resources/software/smalt/smalt-"${PV}".tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

S="${WORKDIR}"/smalt-"${PV}"

src_install(){
	use x86 && newbin smalt_i386 smalt
	use amd64 && newbin smalt_x86_64 smalt
	use ia64 && newbin smalt_ia64

	dodoc NEWS smalt_manual.pdf
	doman smalt.1
}
