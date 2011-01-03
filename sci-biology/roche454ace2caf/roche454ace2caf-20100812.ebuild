# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Perl-based tools to manipulate caf, gap, ace files used in genome assembly"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/roche454ace2gap-2010-12-08.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
		sci-biology/align_to_scf
		sci-biology/sff_dump
		sci-biology/caftools
		sci-biology/staden"

S="${WORKDIR}"/roche2gap

src_install(){
	dobin bin/*.pl
	#newbin bin/align_to_scf-Linux align_to_scf
	#newbin bin/sff_dump-Linux sff_dump
}
