# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Predict proteins from EST sequences overcoming errors in ORFs"
HOMEPAGE="http://www.compsysbio.org/lab/?q=prot4EST"
SRC_URI="http://www.compsysbio.org/lab/james/prot4EST_rl3.1b.tgz"

#http://www.biomedcentral.com/1471-2105/5/187
LICENSE="GPL-1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sci-biology/emboss
	sci-biology/estscan
	sci-biology/bioperl
	virtual/perl-File-Path
	virtual/perl-Getopt-Long
	dev-perl/Statistics-Descriptive
	dev-perl/Tie-IxHash"
	#dev-perl/Algorithm-Loops
	#dev-perl/File-Copy

RDEPEND="${DEPEND}"

S="${WORKDIR}"/"p4e3.1b"

src_install(){
	mydoc="README"
	perl-module_src_install
	mv bin/prot4EST*.pl bin/prot4EST.pl
	dobin bin/*.pl
	dodoc doc/*
}
