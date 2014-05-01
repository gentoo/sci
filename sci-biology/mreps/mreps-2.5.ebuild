# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Identification of serial/tandem repeats in DNA sequences"
HOMEPAGE="http://bioinfo.lifl.fr/mreps/"
SRC_URI="http://bioinfo.lifl.fr/mreps/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	sed -i 's/CC\s*=\s*gcc/CC := ${CC} ${CFLAGS}/' "${S}/Makefile"
}

src_install() {
	dobin mreps
}
