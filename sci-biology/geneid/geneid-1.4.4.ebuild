# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="An ab initio exon/gene finding program"
HOMEPAGE="http://genome.crg.es/software/geneid"
SRC_URI="ftp://genome.crg.es/pub/software/geneid/geneid_v1.4.4.Jan_13_2011.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"

src_prepare() {
	epatch "${FILESDIR}"/Makefile.patch
}

src_install() {
	dobin bin/geneid
	dohtml docs/*.html
	dohtml -r docs/chapter*
	dohtml -r docs/images
}
