# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULE_AUTHOR=""
inherit perl-module

DESCRIPTION="EnsEMBL Perl API aka ensembl-api exposing Bio::EnsEMBL::Registry"
HOMEPAGE="https://www.ensembl.org/index.html"
SRC_URI="ftp://ftp.ensembl.org/pub/ensembl-api.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

S="${WORKDIR}"

src_install(){
	perl_set_version
	find . -name t | xargs rm -rf || die
	find . -name test.pl | xargs rm -f || die
	find . -name \*.example | xargs rm -f || die
	find . -name \*.json | xargs rm -f || die
	find . -name README* | xargs rm -rf || die
	find . -name \*.conf | xargs rm -f || die
	find . -name travisci | xargs rm -rf || die
	find . -name sql | xargs rm -rf || die
	find . -name modules | while read d; do pushd "$d"; perl_domodule -r *; popd; done || die
}
