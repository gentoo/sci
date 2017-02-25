# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Analyze and trim single-end and paired-end reads, show quality statistics"
HOMEPAGE="http://sourceforge.net/projects/clview"
SRC_URI="http://sourceforge.net/projects/solexaqa/files/src/SolexaQA_v.2.2.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-lang/perl
	dev-lang/R"
RDEPEND="${DEPEND}"

S=${WORKDIR}/"${PN}"_v."${PV}"

src_install(){
	dobin *.pl
}
