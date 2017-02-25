# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MODULE_AUTHOR=""
inherit perl-module

DESCRIPTION="EnsEMBL Perl API aka ensembl-api exposing Bio::EnsEMBL::Registry"
SRC_URI="ftp://ftp.ensembl.org/pub/ensembl-api.tar.gz"

#LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install(){
	perl_set_version
	insinto "${VENDOR_LIB}" # do not add "${PN}" so the the PERL path starts with Bio/
	find . -name t | xargs rm -rf || die
	find . -name test.pl | xargs rm -f || die
	find . -name \*.example | xargs rm -f || die
	find . -name \*.json | xargs rm -f || die
	find . -name README* | xargs rm -rf || die
	find . -name \*.conf | xargs rm -f || die
	find . -name travisci | xargs rm -rf || die
	find . -name sql | xargs rm -rf || die
	find . -name modules | while read d; do pushd "$d"; doins -r *; popd; done || die
}
