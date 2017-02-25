# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Check de novo assembly for chimeric contigs/transcripts"
HOMEPAGE="http://www.bcgsc.ca/platform/bioinfo/software/barnacle"
#SRC_URI="http://www.bcgsc.ca/platform/bioinfo/software/barnacle/releases/1.0.0/"${P}".tar.gz"
SRC_URI="http://www.bcgsc.ca/platform/bioinfo/software/barnacle/releases/${PV}/${P}.tar.gz"
# ftp://ftp.bcgsc.ca/supplementary/Barnacle_BMC_Genomics/aml_data.tar.gz
# http://www.bcgsc.ca/platform/bioinfo/software/barnacle/releases/1.0.3

LICENSE="bcca_2010"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${S}"

# follow README.txt
src_compile(){
	cd src || die
	# Run setup.py to compile the portions of Barnacle that require compilation, and download and setup the default annotations
	touch alignment_processing/gap_realigner_cluster || die # prevent compilation on a cluster
	./setup.py localhost || die
}

src_install(){
	dodoc README.txt
	cd src || die
	# do something
}
