# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module

DESCRIPTION="Gene prediction based on RNA-Seq using GeneMark-ET and AUGUSTUS"
# http://bioinf.uni-greifswald.de/bioinf/publications/pag2015.pdf
HOMEPAGE="http://bioinf.uni-greifswald.de/augustus/downloads"
SRC_URI=" http://bioinf.uni-greifswald.de/augustus/binaries/BRAKER1.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	virtual/perl-Scalar-List-Utils"
#
# BUG:
# this causes:
# [blocks B      ] <perl-core/Scalar-List-Utils-1.380.0 ("<perl-core/Scalar-List-Utils-1.380.0" is blocking virtual/perl-Scalar-List-Utils-1.380.0)

S="${WORKDIR}"

src_install(){
	perl_set_version
	dobin *.pl
	insinto ${VENDOR_LIB}/${PN}
	doins *.pm
	dodoc README.braker
}
