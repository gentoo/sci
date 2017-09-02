# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Variant analysis tools from whole exome capture sequencing (WECS)"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas2"
SRC_URI="http://downloads.sourceforge.net/project/atlas2/Atlas2_v1.4.3.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sci-biology/samtools:0
	sci-biology/blat
	sci-biology/phrap
	sci-biology/ucsc-genome-browser" # that provides bigWig.h and jkweb.a, aka Jim Kent's src
RDEPEND="${DEPEND}"

S="${WORKDIR}"/all/"${PN}"_v"${PV}"

src_compile(){
	cd SOLiD-SNP-caller || die
	default

	cd ../vcfPrinter || die
	# TODO: install the *.rb files

	cd ../Atlas-Indel2 || die
	# TODO: install the *.rb and files in lib/

	cd ../Atlas-SNP2 || die
	# TODO: install
}
