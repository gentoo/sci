# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Tool to close gaps in de novo assembled contigs or scaffolds"
HOMEPAGE="http://www.bioinfo.ufpr.br/fgap"
SRC_URI="https://sourceforge.net/projects/fgap/files/FGAP_1_8_1_LINUX64b.tar.gz"
# http://bmcresnotes.biomedcentral.com/articles/10.1186/1756-0500-7-371

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# Matlab (R2012a) or Octave (3.6.2)
# fag from sci-biology/fgap-bin needs /usr/local/MATLAB/R2012a/bin/glnx86/libmwi18n.so, which comes from MATLAB
# export LD_LIBRARY_PATH= /usr/local/MATLAB/R2012a/bin/glnx86
#
# Source code (Octave/Matlab): https://sourceforge.net/projects/fgap/files/fgap.m

# MATLAB Component Runtime v7.17: https://sourceforge.net/projects/fgap/files/MCR_LINUX64b.tar.gz
# http://www.mathworks.com/products/compiler/mcr/index.html
DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/ncbi-tools++"
S="${WORKDIR}"/FGAP_1_8_1_LINUX64b

src_install(){
	dobin run_fgap.sh fgap
	dodoc README
	insinto /usr/share/"${PN}"/sample_data
	doins sample_data/*.fasta
}
