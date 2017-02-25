# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Predict proteins from EST sequences overcoming frameshifts"
HOMEPAGE="http://www.compsysbio.org/lab/?q=prot4EST
	http://www.biomedcentral.com/1471-2105/5/187"
SRC_URI="http://www.compsysbio.org/lab/james/prot4EST_rl3.1b.tgz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/emboss
	sci-biology/estscan
	sci-biology/bioperl
	sci-biology/ncbi-tools
	virtual/perl-File-Path
	virtual/perl-Getopt-Long
	dev-perl/Statistics-Descriptive
	dev-perl/Tie-IxHash
	dev-perl/Algorithm-Loops"
	# sci-biology/DECODER
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"p4e3.1b"

src_install(){
	mydoc="README INSTALL"
	perl-module_src_install
	mv bin/prot4EST*.pl bin/prot4EST.pl
	dobin bin/*.pl
	dodoc doc/*
}
