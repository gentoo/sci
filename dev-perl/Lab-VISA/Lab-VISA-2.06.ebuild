# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Perl interface to National Instrument's VISA library"
HOMEPAGE="http://www.labvisa.de/"
SRC_URI="mirror://cpan/authors/id/S/SC/SCHROEER/Lab/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl sci-libs/ni-visa"
RDEPEND="${DEPEND}"
