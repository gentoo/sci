# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions

DESCRIPTION="Optimise Velvet sequence assembler"
HOMEPAGE="http://www.vicbioinformatics.com/software.velvetoptimiser.shtml"
SRC_URI="http://www.vicbioinformatics.com/"${P}".tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/bioperl-1.4
	>=sci-biology/velvet-0.7.5.1
	dev-lang/perl[ithreads]" # actually >=5.8 but make sure 5.16 is recognized as > 5.8, heh

src_install(){
	dobin VelvetOptimiser.pl
	perl_set_version
	insinto ${VENDOR_LIB}/VelvetOpt
	doins VelvetOpt/*.pm
	dodoc README INSTALL CHANGELOG
}
