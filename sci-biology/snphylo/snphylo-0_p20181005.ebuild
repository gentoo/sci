# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="55cc9a45dc1d0064c94a3e8bea8fdb7c00656556"

DESCRIPTION="Pipeline to generate phylogenetic tree from SNP data"
HOMEPAGE="https://github.com/thlee/SNPhylo"
SRC_URI="https://github.com/thlee/SNPhylo/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND="
	sci-biology/fastdnaml
	sci-biology/muscle
	sci-biology/phylip
	dev-lang/R
"
DEPEND="${RDEPEND}"
# http://chibba.pgml.uga.edu/snphylo/install_on_linux.html
# R packages (phangorn, gdsfmt, SNPRelate and getopt)
# $ apt-get -y install r-base-dev r-cran-getopt r-cran-rgl

S="${WORKDIR}/SNPhylo-${COMMIT}"

src_compile(){
	bash setup.sh || die
}

src_install(){
	dobin snphylo.sh
}
