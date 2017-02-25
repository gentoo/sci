# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Utilities for RNA-seq data quality control"
HOMEPAGE="http://rseqc.sourceforge.net"
SRC_URI="http://sourceforge.net/projects/rseqc/files/RSeQC-2.6.1.tar.gz
	http://sourceforge.net/projects/rseqc/files/other/fetchChromSizes"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sci-biology/pysam-0.7.5[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# pysam (v0.7.5) was built in RSeQC. The latest version of pysam may not be compatible with RSeQC.
python_install(){
	distutils-r1_python_install
	rm -r "${D}$(python_get_sitedir)"/pysam
	dobin "${DISTDIR}"/fetchChromSizes
}
