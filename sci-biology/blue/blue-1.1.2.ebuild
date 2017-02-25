# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Error corrector for Illummina and Roche/454, inculding insertions and deletions"
HOMEPAGE="http://www.bioinformatics.csiro.au/blue"
SRC_URI="
	http://www.bioinformatics.csiro.au/public/files/Linux-${PV}.tar.gz -> ${P}.tar.gz
	http://www.bioinformatics.csiro.au/public/files/Correcting_reads_with_Blue.pdf -> ${P}-Correcting_reads_with_Blue.pdf
	http://www.bioinformatics.csiro.au/public/files/Changes_for_Blue_1.1.3.pdf -> ${P}-Changes_for_Blue_${PV}.pdf"
LICENSE="GPL-2+"
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
	# one could install also the *.exe.so files for speedup into /usr/bin/

	# The -hp option sets a flag that is checked when Blue is scanning along a read trying to find errors that could be corrected. There are a number of tests done at every base position, all based on depth of coverage. These tests will pick up random indel errors, but indels are so common at the end of homopolymer runs in 454 and IonTorrent data that multiple hp run lengths all look to be OK. For example, if our genome had AAAAAA then with Illumina data this is what we'd see almost all the time, with very rare indels at the end of the hp run resulting in runs of 5 or 7 As. With 454-like data, we'd probably get 5 As as frequently as 6 As so depth of coverage would say that neither of them are errors. The -hp flag looks out for the end of hp runs and forces an attempt at correction at that point. If the read wasn't in error, then no correction will be made.

	# In general Blue will correct Ns - if a correct replacement can be found. The only time it doesn't do this is if there are too many consecutive Ns - as the process of finding likely replacements is combinatoric and the cost goes up exponentially with the number of consecutive Ns. In these cases, the read is abandoned and passed through uncorrected. Can you give an example of a read that you would like to see corrected differently?
}

# it's author uses 'mono-sgen /usr/bin/Blue.exe' to use the alternative garbage collector
