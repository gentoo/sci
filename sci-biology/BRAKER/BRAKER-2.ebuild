# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module

DESCRIPTION="Gene prediction based on RNA-Seq using GeneMark-ET and AUGUSTUS"
# http://bioinf.uni-greifswald.de/bioinf/publications/pag2015.pdf
HOMEPAGE="http://bioinf.uni-greifswald.de/bioinf/braker
	http://bioinf.uni-greifswald.de/augustus/downloads"
SRC_URI="http://bioinf.uni-greifswald.de/augustus/binaries/BRAKER"${PV}".tar.gz -> ${P}.tar.gz"
# Download BRAKER1 from http://bioinf.uni-greifswald.de/augustus/binaries/BRAKER1.tar.gz.
# The most recent release is version 1.8, from December 15th 2015.
# Example data for testing the BRAKER1 pipeline is available at
# http://bioinf.uni-greifswald.de/augustus/binaries/BRAKER1examples.tar.gz (1.1 GB).

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-perl/Scalar-Util-Numeric
	sci-biology/augustus"
	#>=sci-biology/GeneMark_ET-bin-4.29"
#
# BUG:
# this causes:
# [blocks B      ] <perl-core/Scalar-List-Utils-1.380.0 ("<perl-core/Scalar-List-Utils-1.380.0" is blocking virtual/perl-Scalar-List-Utils-1.380.0)

S="${WORKDIR}"/BRAKER_v"${PV}".0

src_prepare(){
	sed -e 's/^use helpMod/use BRAKER::helpMod/' -i braker.pl || die
}

src_install(){
	perl_set_version
	dobin *.pl
	insinto ${VENDOR_LIB}/${PN}
	doins *.pm
	dodoc README.braker
}

pkg_postinst(){
	einfo "Please install sci-biology/GeneMark_ET after obtaininig a license and binaries from"
	einfo "http://exon.gatech.edu/GeneMark/gmes_instructions.html"
}
