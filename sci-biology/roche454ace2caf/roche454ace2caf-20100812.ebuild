# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ace to gap4 converter"
HOMEPAGE="https://genome.imb-jena.de/software/roche454ace2caf/"
SRC_URI="https://genome.imb-jena.de/software/roche454ace2caf/download/src/roche454ace2gap-2010-12-08.tgz"

LICENSE="FLI-Jena"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
	sci-biology/align_to_scf
	sci-biology/sff_dump
	sci-biology/caftools
	sci-biology/staden
	dev-lang/perl
	app-shells/ksh"

S="${WORKDIR}/roche2gap"

src_install(){
	dobin bin/*.pl bin/roche454ace2gap
	einstalldocs
}
