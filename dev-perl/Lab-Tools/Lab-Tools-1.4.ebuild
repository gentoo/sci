# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Tools for use with dev-perl/Lab-Instrument"
HOMEPAGE="http://www.labvisa.de/"
SRC_URI="mirror://cpan/authors/id/S/SC/SCHROEER/Lab/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/XML-Generator
	dev-perl/XML-DOM
	dev-perl/XML-Twig
	sci-visualization/gnuplot
	virtual/perl-encoding-warnings
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"
