# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="Optimise Velvet sequence assembler"
HOMEPAGE="https://vicbioinformatics.com/software.velvetoptimiser.shtml"
SRC_URI="https://github.com/tseemann/VelvetOptimiser/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sci-biology/bioperl-1.4
	>=sci-biology/velvet-0.7.5.1
	dev-lang/perl[perl_features_ithreads]" # actually >=5.8 but make sure 5.16 is recognized as > 5.8, heh

src_install(){
	dobin VelvetOptimiser.pl
	perl_set_version
	perl_domodule VelvetOpt/*.pm
	einstalldocs
}
