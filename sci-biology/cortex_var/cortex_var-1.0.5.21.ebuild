# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit perl-functions

DESCRIPTION="Genotype variant discovery without reference sequence"
HOMEPAGE="http://cortexassembler.sourceforge.net/index_cortex_var.html" # no https
SRC_URI="
	https://sourceforge.net/projects/cortexassembler/files/cortex_var/latest/CORTEX_release_v${PV}.tgz
	http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

# http://www.well.ox.ac.uk/project-stampy

DEPEND="
	sci-biology/vcftools
	sci-libs/gsl
	sci-libs/htslib:0=
	dev-lang/perl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/CORTEX_release_v${PV}"

src_prepare(){
	default
	sed -e "s/ -O3 / ${CFLAGS} /" Makefile || die
	sed -e "s#libs/gsl-1.15#${EPREFIX}/usr/include/gsl#" Makefile || die
}

src_compile(){
	rm -rf libs/htslib libs/gsl-1.15 || die
	emake NUM_COLS=1 MAXK=31 cortex_var || die
}

src_install(){
	bash install.sh || die
	perl_set_version
	insinto ${VENDOR_LIB}
	doins scripts/analyse_variants/bioinf-perl/lib/* scripts/calling/*
	echo \
		"PATH=${EPREFIX}/usr/share/${PN}/scripts/analyse_variants/needleman_wunsch" \
		> "${T}/99${PN}" || die
	doenvd "${T}/99${PN}"
	dodoc "${DISTDIR}"/cortex_var_user_manual.pdf
}
