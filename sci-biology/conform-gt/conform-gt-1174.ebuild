# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Modify your Variant Call Format file to be consistent with reference VCF"
HOMEPAGE="http://faculty.washington.edu/browning/conform-gt.html"
SRC_URI="http://faculty.washington.edu/browning/conform-gt/conform-gt.r1174.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
# Some source files in the net.sf.samtools package are licensed under the MIT License.

# http://bochet.gcc.biostat.washington.edu/beagle/1000_Genomes_phase1_vcf/

S="${WORKDIR}"/src
