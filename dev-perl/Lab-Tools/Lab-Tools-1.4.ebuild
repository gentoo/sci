# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="Tools for use with dev-perl/Lab-Instrument"
HOMEPAGE="http://www.labvisa.de/"
SRC_URI="mirror://cpan/authors/id/S/SC/SCHROEER/Lab/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/perl
	perl-core/Time-HiRes
	dev-perl/XML-Generator
	dev-perl/XML-DOM
	dev-perl/XML-Twig
	perl-core/encoding-warnings
	sci-visualization/gnuplot"
DEPEND="${RDEPEND} virtual/perl-Module-Build"
