# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Analyze and trim single-end and paired-end reads, show quality statistics"
HOMEPAGE="https://sourceforge.net/projects/clview"
SRC_URI="https://sourceforge.net/projects/solexaqa/files/src/SolexaQA_v.${PV}.zip"

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
