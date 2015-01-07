# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Error corrector for Illummina and Roche/454 able to also fix insertions and deletions"
HOMEPAGE="http://www.csiro.au/Outcomes/ICT-and-Services/Software/Blue.aspx"
SRC_URI="http://www.csiro.au/~/media/CSIROau/Images/Bioinformatics/Blue_software/Version_1-1-2/Linux112.ashx -> "${P}".tar.gz
	http://www.csiro.au/~/media/CSIROau/Images/Bioinformatics/Blue_software/Version_1-1-2/Correcting_reads_with_Blue.ashx -> Correcting_reads_with_Blue.pdf"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/Linux

src_compile(){
	Blue/compile.sh || die
	Tessel/compile.sh || die
	GenerateMerPairs/compile.sh || die
}

src_install(){
	dobin Tessel.exe GenerateMerPairs.exe Blue.exe
	# BUG: probably have to install also the *.exe.so files
}
