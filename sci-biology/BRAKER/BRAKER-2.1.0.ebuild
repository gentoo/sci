# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module

DESCRIPTION="Gene prediction based on RNA-Seq using GeneMark-ET and AUGUSTUS"
# http://bioinf.uni-greifswald.de/bioinf/publications/pag2015.pdf
HOMEPAGE="http://bioinf.uni-greifswald.de/bioinf/braker
	http://bioinf.uni-greifswald.de/augustus/downloads"
SRC_URI="http://bioinf.uni-greifswald.de/augustus/binaries/BRAKER_v"${PV}".tar.gz -> ${P}.tar.gz"
# Example data for testing the BRAKER2 pipeline is available at
# http://bioinf.uni-greifswald.de/augustus/binaries/BRAKER2examples.tar.gz (1.1 GB).

# BRAKER2 is using the Artistic-1.0 version without clause 8 about
# commercial distribution
# See discussion at https://opensource.org/licenses/artistic-license-1.0
# Practically the license is same as http://dev.perl.org/licenses/artistic.html
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-perl/Scalar-Util-Numeric
	sci-biology/augustus"
	#>=sci-biology/GeneMark_ET-bin-4.29"

S="${WORKDIR}"/BRAKER_v"${PV}"

src_install(){
	perl_set_version
	dobin *.pl
	insinto ${VENDOR_LIB}/${PN}
	doins *.pm
	dodoc userguide.pdf
}

pkg_postinst(){
	einfo "Please install sci-biology/GeneMark_ET after obtaininig a license and binaries from"
	einfo "http://exon.gatech.edu/GeneMark/gmes_instructions.html"
}
