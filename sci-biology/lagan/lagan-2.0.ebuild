# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils

MY_PV="20"

DESCRIPTION="LAGAN, Multi-LAGAN, Shuffle-LAGAN, Supermap: Whole-genome multiple alignment of genomic DNA"
HOMEPAGE="http://lagan.stanford.edu/lagan_web/index.shtml"
SRC_URI="http://lagan.stanford.edu/lagan_web/lagan${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/lagan${MY_PV}"

src_unpack() {
	unpack ${A}
	sed -i "/use Getopt::Long;/ i use lib \"/usr/share/${PN}/lib\";" "${S}/supermap.pl" || die
	epatch "${FILESDIR}"/${P}-*.patch
}

src_install() {
	dobin lagan.pl slagan.pl mlagan
	rm lagan.pl slagan.pl utils/Utils.pm
	dodir /usr/share/${PN}/lib
	insinto /usr/share/${PN}/lib
	doins Utils.pm
	exeinto /usr/share/${PN}/utils
	doexe utils/*
	exeinto /usr/share/${PN}
	doexe *.pl anchors chaos glocal order prolagan
	insinto /usr/share/${PN}
	doins *.txt
	dosym /usr/share/${PN}/supermap.pl /usr/bin/supermap
	dosym /usr/bin/lagan.pl /usr/bin/lagan
	dosym /usr/bin/slagan.pl /usr/bin/slagan
	echo "LAGAN_DIR=\"/usr/share/${PN}\"" > ${S}/99${PN}
	doenvd "${S}/99${PN}"
	dodoc Readmes/README.*
}
