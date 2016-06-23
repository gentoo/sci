# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

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

S="${WORKDIR}"/atlas-src

src_compile(){
	# install headers, bins and libs into CBT_DEVEL_USER, then compile apps
	cd src || die
	emake CBT_DEVEL_DIR="${S}"/CBT CBT_INSTALL_DIR="${D}"
	cd ../CBTApps || die
	emake CBT_DEVEL_DIR="${S}"/CBT CBT_INSTALL_DIR="${D}"
}
