# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-module

DESCRIPTION="Predict proteins from EST sequences overcoming errors in ORFs"
HOMEPAGE="http://www.compsysbio.org/lab/?q=prot4EST"
SRC_URI="http://www.compsysbio.org/lab/james/prot4EST_rl3.1b.tgz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/emboss
	sci-biology/estscan
	sci-biology/bioperl
	dev-perl/Algorithm-Loops
	perl-core/File-Path
	dev-perl/File-Copy
	perl-core/Getopt-Long
	dev-perl/Statistics-Descriptive
	dev-perl/Tie-IxHash"

RDEPEND="${DEPEND}"

S="${WORKDIR}"/"p4e3.1b"

src_install(){
	mydoc="README"
	perl-module_src_install
	dobin bin/*.pl
	dodoc doc/*
}
