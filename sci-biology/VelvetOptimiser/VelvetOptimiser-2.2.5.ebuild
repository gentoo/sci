# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="Optimise three primary parameter options (K, -exp_cov, -cov_cutoff) for Velvet sequence assembler."
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
	>=dev-lang/perl-5.8[ithreads]"

src_install(){
	dobin VelvetOptimiser.pl
	insinto ${VENDOR_LIB}/${PN}
	doins VelvetOpt/*.pm
	dodoc README INSTALL CHANGELOG || die
}
