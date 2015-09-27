# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Interface to an instrument via GPIB, serial bus or ethernet"
HOMEPAGE="http://www.labvisa.de/"
SRC_URI="mirror://cpan/authors/id/S/SC/SCHROEER/Lab/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="
	dev-lang/perl
	dev-perl/Lab-VISA
	virtual/perl-Time-HiRes
	"
DEPEND="${RDEPEND}
	virtual/perl-Module-Build"
