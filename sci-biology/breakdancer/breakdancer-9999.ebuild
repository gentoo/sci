# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

[ "$PV" == "9999" ] && inherit git-r3

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Genome-wide detection of structural variants from next generation paired-end sequencing reads"
HOMEPAGE="http://gmt.genome.wustl.edu/packages/breakdancer"
if [ "$PV" == "9999" ]; then
	EGIT_REPO_URI="https://github.com/genome/breakdancer.git"
	KEYWORDS=""
else
	# TODO: fish out 1.3.6 version from github
	SRC_URI="http://sourceforge.net/projects/breakdancer/files/breakdancer-1.1.2_2013_03_08.zip"
	KEYWORDS=""
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

# http://search.cpan.org/~callahan/Math-CDF-0.1/CDF.pm
DEPEND="dev-lang/perl
	dev-perl/Statistics-Descriptive
	sci-biology/samtools"
RDEPEND="${DEPEND}"
