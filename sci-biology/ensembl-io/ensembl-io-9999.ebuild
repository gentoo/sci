# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 perl-functions

DESCRIPTION="The Ensembl IO Perl API and SQL schema"
HOMEPAGE="http://www.ensembl.org/info/docs/api/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/Ensembl/${PN}.git"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="sci-biology/bioperl"
RDEPEND="${DEPEND}
	sci-biology/ensembl"

src_install() {
	perl_set_version
	insinto /usr/lib/perl5/${PERL_VERSION}
	doins -r modules/*
	rm -r "${ED}"/usr/lib/perl5/${PERL_VERSION}/t || die

	dodoc doc/*.txt
}
