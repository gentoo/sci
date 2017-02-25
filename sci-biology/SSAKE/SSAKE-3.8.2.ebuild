# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Short-read trimmer, OLC assembler, scaffolder in PERL using the 3'-most k-mers"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/ssake"
SRC_URI="http://www.bcgsc.ca/platform/bioinfo/software/ssake/releases/${PV}/ssake_v3-8-2.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

# pure perl
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/ssake_v3-8-2

src_install(){
	dobin SSAKE
	dodoc SSAKE.pdf SSAKE.readme
	insinto /usr/share/${PN}/tools
	doins tools/*
	insinto /usr/share/${PN}/test
	doins test/*
}
