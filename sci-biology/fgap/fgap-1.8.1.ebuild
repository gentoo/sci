# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Tool to close gaps in de novo assembled contigs or scaffolds"
HOMEPAGE="http://www.bioinfo.ufpr.br/fgap"
SRC_URI="https://sourceforge.net/projects/fgap/files/fgap.m"
# http://bmcresnotes.biomedcentral.com/articles/10.1186/1756-0500-7-371

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

# Matlab (R2012a) or Octave (3.6.2)
#
# Source code (Octave/Matlab): https://sourceforge.net/projects/fgap/files/fgap.m

# MATLAB Component Runtime v7.17: https://sourceforge.net/projects/fgap/files/MCR_LINUX64b.tar.gz
# http://www.mathworks.com/products/compiler/mcr/index.html
DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/ncbi-tools-2.2.28
	>=sci-mathematics/octave-3.6.2"
