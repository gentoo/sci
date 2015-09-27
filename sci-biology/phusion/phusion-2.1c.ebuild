# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Whole genome shotgun assembler using phrap (for Sanger-based reads)"
HOMEPAGE="http://www.sanger.ac.uk/resources/software/phusion/"
SRC_URI="ftp://ftp.sanger.ac.uk/pub/resources/software/phusion/phusion_pipeline_v2.1c.tar.gz"

LICENSE="all-rights-reserved" # temporarily placed value
# from http://genome.cshlp.org/content/13/1/81.full
# Availability
# Phusion is undergoing a rewrite of the code to make this a portable package. It will be made available free of charge to academic sites, but requires licensing for commercial use. For more information please contact the authors.
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-shells/tcsh"
RDEPEND="${DEPEND}
	sci-biology/phrap
	dev-lang/perl"

# contains bundled ssaha
# file collision with sci-biology/shrimp on /usr/bin/fasta2fastq

S="${WORKDIR}"/"phusion_pipeline_v2.1c"

src_prepare(){
	cp -pf /usr/bin/phrap src/phrap/phrap.manylong || die
}

src_compile(){
	tcsh install.csh || csh install.csh || die
}

src_install(){
	dobin bin/*
	dodoc README.1st releaseNote_v2.1c doc/*
}
