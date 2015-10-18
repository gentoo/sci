# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby19 ruby20"

inherit ruby-fakegem

DESCRIPTION="Variant analysis tools (true SNPs, insertions, deletions) from whole exome capture sequencing (WECS)"
HOMEPAGE="https://www.hgsc.bcm.edu/software/atlas2"
SRC_URI="http://downloads.sourceforge.net/project/atlas2/Atlas2_v1.4.3.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	sci-biology/samtools
	sci-biology/blat
	sci-biology/phrap
	sci-biology/ucsc-genome-browser" # that provides bigWig.h and jkweb.a, aka Jim Kent's src
RDEPEND="${DEPEND}"

S="${WORKDIR}"/all/"${PN}"_v"${PV}"

src_compile(){
	cd SOLiD-SNP-caller || die
	default

	cd ../vcfPrinter
	# TODO: install the *.rb files

	cd ../Atlas-Indel2
	# TODO: install the *.rb and files in lib/

	cd ../Atlas-SNP2
	# TODO: install
}
