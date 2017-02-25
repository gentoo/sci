# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 perl-functions

DESCRIPTION="Genome-wide detection of structural variants from paired-end sequencing reads"
HOMEPAGE="http://gmt.genome.wustl.edu/packages/breakdancer"
EGIT_REPO_URI="https://github.com/genome/breakdancer.git"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS=""

# http://search.cpan.org/~callahan/Math-CDF-0.1/CDF.pm
DEPEND="
	dev-lang/perl
	dev-perl/Statistics-Descriptive
	sci-biology/samtools:0"
RDEPEND="${DEPEND}"
