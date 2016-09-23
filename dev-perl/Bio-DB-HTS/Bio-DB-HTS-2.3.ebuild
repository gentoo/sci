# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# this is https://metacpan.org/pod/Bio::DB::HTS and not https://metacpan.org/pod/Bio::HTS
# this is https://github.com/Ensembl/Bio-DB-HTS
MODULE_AUTHOR="RISHIDEV"
inherit perl-module multilib toolchain-funcs

DESCRIPTION="Enable rapid access to bgzipped FASTA files"

#LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	sci-libs/htslib"

SRC_TEST="do"

src_prepare(){
	# https://github.com/Ensembl/Bio-HTS/issues/15
	# https://github.com/Ensembl/Bio-HTS/issues/30
	HTSLIB_LIBDIR="${EPREFIX}"/"$(get_libdir)" HTSLIB_INCDIR="${EPREFIX}"/usr/include/htslib perl-module_src_prepare
}
