# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="A rewrite and improvement upon sim4, a DNA-mRNA aligner"
HOMEPAGE="http://sibsim4.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/SIBsim4-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/SIBsim4-${PV}"

src_unpack() {
	unpack ${A}
	sed -i 's/CFLAGS = \(.*\)/CFLAGS := \1 ${CFLAGS}/' ${S}/Makefile
}

src_install() {
	dobin SIBsim4
	doman SIBsim4.1
}
