# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Atlas Whole Genome Assembly Suite"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas-whole-genome-assembly-suite"
SRC_URI="https://www.hgsc.bcm.edu/sites/default/files/software/Atlas/atlas-src.tgz"
# https://www.hgsc.bcm.edu/sites/default/files/software/Atlas/atlas2005-linux.tgz

LICENSE="ATLAS"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/boost"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/atlas-src/CBT

src_prepare(){
	sed -e "s/^CC = .*/CC = $(tc-getCC)/" -e "s/^GCC = .*/GCC = $(tc-getCXX)/" -i Makefile || die
	sed -e "s/^CC = .*/CC = $(tc-getCC)/" -e "s/^GCC = .*/GCC = $(tc-getCXX)/" -i ../CBTApps/Makefile.in || die
	sed -e "s@^# CBT_DEVEL_USER = .*@CBT_DEVEL_USER = ${EPREFIX}/@" -i Makefile || die
	sed -e "s@^# CBT_DEVEL_USER = .*@CBT_DEVEL_USER = ${EPREFIX}/@" -i Makefile.in || die
	sed -e "s#^CBT_INSTALL_LIB = /home/hgsc/lib/#CBT_INSTALL_LIB = ${EPREFIX}/usr/lib/#" -i Makefile || die
	sed -e "s#^CBT_INSTALL_LIB = /home/hgsc/lib/#CBT_INSTALL_LIB = ${EPREFIX}/usr/lib/#" -i Makefile.in || die
	sed -e "s#^BOOST_DIR = .*#BOOST_DIR = ${EPREFIX}/usr/lib/#" -i Makefile || die
	sed -e "s#^BOOST_DIR = .*#BOOST_DIR = ${EPREFIX}/usr/lib/#" -i Makefile.in || die
	sed -e "s#^CXX = .*#CXX = $(tc-getCXX)#" -i gzstream/Makefile || die
}

src_compile(){
	# install headers, bins and libs into CBT_DEVEL_USER, then compile apps
	emake CBT_DEVEL_DIR="${WORKDIR}/atlas-src/CBT" CBT_INSTALL_DIR="${D}"/"${EPREFIX}"
	cd ../CBTApps || die
	emake CBT_DEVEL_DIR="${WORKDIR}/atlas-src/CBTApps" CBT_INSTALL_DIR="${D}"/"${EPREFIX}"
}
