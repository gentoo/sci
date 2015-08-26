# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit perl-module eutils toolchain-funcs

DESCRIPTION="Assemble and compare genotype variants (variant discovery without reference sequence)"
HOMEPAGE="http://cortexassembler.sourceforge.net/index_cortex_var.html"
SRC_URI="http://sourceforge.net/projects/cortexassembler/files/cortex_var/latest/CORTEX_release_v1.0.5.21.tgz
	http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

# http://www.well.ox.ac.uk/project-stampy

DEPEND="sci-biology/vcftools
	sci-libs/gsl
	sci-libs/htslib
	dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/CORTEX_release_v1.0.5.21

src_prepare(){
	sed -e "s/ -O3 / ${CFLAGS} /" Makefile || die
}

src_compile(){
	rm -rf libs/htslib libs/gsl-1.15
	make NUM_COLS=1 MAXK=31 cortex_var || die
}

src_install(){
	bash install.sh || die
	perl_set_version
	insinto ${VENDOR_LIB}
	doins scripts/analyse_variants/bioinf-perl/lib/* scripts/calling/*
	echo "PATH=/usr/share/${PN}/scripts/analyse_variants/needleman_wunsch" >  "${S}/99${PN}"
	doenvd "${S}/99${PN}"
	dodoc "${DISTDIR}"/cortex_var_user_manual.pdf
}
