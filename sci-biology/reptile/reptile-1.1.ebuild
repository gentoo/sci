# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Illumina read corrector"
HOMEPAGE="http://aluru-sun.ece.iastate.edu/doku.php?id=reptile"
SRC_URI="http://aluru-sun.ece.iastate.edu/lib/exe/fetch.php?media=source:reptile-v${PV}.zip -> "${PN}"-v"${PV}".zip"

LICENSE="LGPL-3 GPL-3 Boost-1.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-lang/perl"

S="${WORKDIR}"/"${PN}"-v"${PV}"

src_prepare(){
	sed -e 's#-Wall -O3#$(CXXFLAGS)#' -i src/makefile || die
	sed -e 's#-Wall -O3#$(CXXFLAGS)#' -i utils/reptile_merger/makefile || die
	sed -e 's#-Wall -O3#$(CXXFLAGS)#' -i utils/seq-analy/makefile || die
}

src_compile(){
	cd src || die
	emake all
	cd ../utils/reptile_merger || die
	emake all
	cd ../seq-analy || die
	emake all
}

src_install(){
	newbin src/reptile-v1.1 reptile
	dobin utils/reptile_merger/reptile_merger
	dobin utils/fastq-converter-v2.0.pl
}
