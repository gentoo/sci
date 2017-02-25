# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="CMUNGALL"

inherit perl-module

DESCRIPTION="GO::Parser parses all GO files formats and types"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	>=dev-perl/Data-Stag-0.11
	dev-lang/perl"
RDEPEND="${DEPEND}"
