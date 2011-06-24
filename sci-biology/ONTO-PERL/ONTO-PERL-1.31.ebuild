# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.38.ebuild,v 1.1 2009/05/19 12:22:20 tove Exp $

EAPI=2

MODULE_AUTHOR=EASR
inherit multilib perl-module

DESCRIPTION="Manipulates OBO- and OWL-formatted ontologies (like the Gene Ontology)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_URI="http://search.cpan.org/CPAN/authors/id/E/EA/EASR/ONTO-PERL/ONTO-PERL-1.31.tar.gz"

DEPEND=""
RDEPEND="${DEPEND}
	>=sci-biology/swissknife-1.65
	>=dev-perl/XML-Simple-2.16
	>=dev-perl/XML-Parser-2.34"

SRC_TEST=do
#myconf="LIBS=-L/usr/$(get_libdir)"
