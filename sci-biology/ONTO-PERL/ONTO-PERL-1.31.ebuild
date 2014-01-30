# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

MODULE_AUTHOR=EASR

inherit multilib perl-module

DESCRIPTION="Manipulates OBO- and OWL-formatted ontologies (like the Gene Ontology)"
SRC_URI="mirror://cpan/authors/id/E/EA/EASR/ONTO-PERL/ONTO-PERL-1.31.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/swissknife-1.65
	>=dev-perl/XML-Simple-2.16
	>=dev-perl/XML-Parser-2.34"

SRC_TEST=do
#myconf="LIBS=-L/usr/$(get_libdir)"
