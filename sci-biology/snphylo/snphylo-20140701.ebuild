# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Pipeline to generate phylogenetic tree from SNP data"
HOMEPAGE="http://chibba.pgml.uga.edu/snphylo"
SRC_URI="http://chibba.pgml.uga.edu/snphylo/snphylo.tar.gz -> ${P}.tar.gz"
# http://github.com/thlee/SNPhylo
# http://www.biomedcentral.com/1471-2164/15/162

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/fastdnaml
	sci-biology/muscle
	sci-biology/phylip"
# http://chibba.pgml.uga.edu/snphylo/install_on_linux.html
# R packages (phangorn, gdsfmt, SNPRelate and getopt)
# $ apt-get -y install r-base-dev r-cran-getopt r-cran-rgl

S="${WORKDIR}"/"${PN}"

src_compile(){
	bash setup.sh || die
}

src_install(){
	dobin snphylo.sh
}
