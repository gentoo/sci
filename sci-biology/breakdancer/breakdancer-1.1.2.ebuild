# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Genome-wide detection of structural variants from next generation paired-end sequencing reads"
HOMEPAGE="http://breakdancer.sourceforge.net"
SRC_URI="http://sourceforge.net/projects/breakdancer/files/breakdancer-1.1.2_2013_03_08.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
	dev-perl/Statistics-Descriptive
	dev-perl/Math-CDF
	sci-biology/samtools"
RDEPEND="${DEPEND}"
