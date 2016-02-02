# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="Implementation of the soundex algorithm"
HOMEPAGE="http://search.cpan.org/~rjbs/Text-Soundex-3.05/Soundex.pm"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( Artistic GPL-1+ )"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
