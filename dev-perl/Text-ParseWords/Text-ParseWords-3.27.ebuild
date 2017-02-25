# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="CHORNY"
MODULE_A_EXT="zip"

inherit perl-module

DESCRIPTION="Parse strings containing shell-style quoting"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}"
