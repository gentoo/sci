# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR="CHOCOLATE"
MODULE_A_EXT="tar.gz"

inherit perl-module

DESCRIPTION="Wrappers around perl's builtin looks_like_number function"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"

RDEPEND="${DEPEND}"
