# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit perl-module

DESCRIPTION="Perl module interface to an instrument that is connected via GPIB, serial bus or ethernet"
HOMEPAGE="http://www.labvisa.de/"
SRC_URI="mirror://cpan/authors/id/S/SC/SCHROEER/Lab/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-lang/perl perl-core/Time-HiRes dev-perl/Lab-VISA"
DEPEND="${RDEPEND} virtual/perl-Module-Build"
