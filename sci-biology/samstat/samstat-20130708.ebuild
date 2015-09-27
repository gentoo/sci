# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Show statistics of BAM/SAM (error profiles, nucleotide composition, base quals, len. distribution)"
HOMEPAGE="http://samstat.sourceforge.net"
SRC_URI="http://sourceforge.net/projects/samstat/files/samstat.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"/src

src_compile(){
	default
}

src_install(){
	dobin samstat
}
