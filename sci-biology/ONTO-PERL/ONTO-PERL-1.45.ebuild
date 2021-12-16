# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MODULE_AUTHOR=EASR

inherit perl-module

DESCRIPTION="Manipulates OBO- and OWL-formatted ontologies (like the Gene Ontology)"
HOMEPAGE="https://metacpan.org/release/ONTO-PERL"
SRC_URI="mirror://cpan/authors/id/E/EA/${MODULE_AUTHOR}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=sci-biology/swissknife-1.65
	dev-perl/Date-Manip
	>=dev-perl/XML-Simple-2.16
	>=dev-perl/XML-Parser-2.34
	virtual/perl-File-Path"
DEPEND="${RDEPEND}"

SRC_TEST=do
#myconf="LIBS=-L/usr/$(get_libdir)"
