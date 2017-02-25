# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Error corrector for Roche/454 and IonTorrent data"
HOMEPAGE="http://indra.mullins.microbiol.washington.edu/ICC"
SRC_URI="http://indra.mullins.microbiol.washington.edu/cgi-bin/ICC/info.cgi?ID=ICC_v2.0.1.zip -> ICC_v2.0.1.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-lang/perl
	dev-perl/Parallel-ForkManager
	sci-biology/ncbi-tools++"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install(){
	dobin Scripts/*.pl
	dodoc README.txt
}

#    testing: Blast/Linux/LICENSE      OK
#    testing: Example/exampleReads.fas   OK
#    testing: Example/exampleReads.qual   OK
#    testing: Example/exampleReference.fas   OK
#    testing: README.md                OK
#    testing: README.txt               OK
#    testing: Scripts/                 OK
#    testing: Scripts/CC.pl            OK
#    testing: Scripts/HIC.pl           OK
#    testing: Scripts/IC.pl            OK
#    testing: Scripts/alignRegion.pl   OK
#    testing: Scripts/config.pl        OK
#    testing: Scripts/lib/             OK
#    testing: Scripts/lib/.DS_Store    OK
#    testing: Scripts/lib/Parallel/    OK
#    testing: Scripts/lib/Parallel/ForkManager.pm   OK
#    testing: Scripts/lib/paths.pm     OK
#    testing: Scripts/lib/seqAlign.pm   OK
#    testing: Scripts/lib/utils.pm     OK
#    testing: Scripts/ntFreq.pl        OK
#    testing: Scripts/readQualFilter.pl   OK
#    testing: Scripts/retrieveRegion.pl   OK
#    testing: Scripts/retrieveWindows.pl   OK
#    testing: Scripts/runBLAST.pl      OK
#    testing: Scripts/runICC.pl        OK
#    testing: Scripts/uniqueReads.pl   OK
#    testing: VersionHistory.txt       OK
