# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ace to gap4 converter"
HOMEPAGE="http://genome.imb-jena.de/software/roche454ace2caf"
SRC_URI="http://genome.imb-jena.de/software/roche454ace2caf/download/src/roche454ace2gap-2010-12-08.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/align_to_scf
	sci-biology/sff_dump
	sci-biology/caftools
	sci-biology/staden
	dev-lang/perl
	app-shells/ksh"

S="${WORKDIR}"/roche2gap

src_install(){
	dobin bin/*.pl bin/roche454ace2gap
	dosym bin/roche454ace2gap roche2gap # claims to require ksh, have not tested bash
}
