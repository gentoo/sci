# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit perl-module

DESCRIPTION="Warn on implicit encoding conversions"
HOMEPAGE="http://search.cpan.org/~audreyt/encoding-warnings-0.11/lib/encoding/warnings.pm"
SRC_URI="mirror://cpan/authors/id/A/AU/AUDREYT/encoding-warnings-0.11.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
